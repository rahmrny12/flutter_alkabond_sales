import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/model/transaction_model.dart';
import 'package:flutter_alkabond_sales/model/type_model.dart';
import 'package:flutter_alkabond_sales/pages/success_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';

class SalesController extends GetxController {
  var currentStep = 0.obs;
  var errorMessage = "".obs;
  var successMessage = "".obs;
  List<StoreModel> stores = <StoreModel>[].obs;
  List<ProductModel> products = <ProductModel>[].obs;
  List<TypeModel> productTypes = <TypeModel>[].obs;

  List<Map<String, dynamic>> selectedProductList = <Map<String, dynamic>>[].obs;
  var total = 0.obs;

  var selectedStore = Rxn<StoreModel>();
  var selectedProductType = Rxn<TypeModel>();
  var selectedProduct = Rxn<ProductModel>();

  void addProductToSale() {
    if (selectedProduct.value != null) {
      selectedProductList.add({
        "product": selectedProduct.value,
        "quantity": "0",
        "price": "0",
        "subtotal": 0,
      });
      update();
    }
  }

  void setProductQuantity(int index, String value) {
    if (value.isNotEmpty) {
      selectedProductList[index]['quantity'] = value;
      setProductSubTotal(index, selectedProductList[index]['price'],
          selectedProductList[index]['quantity']);
      update();
    }
  }

  void setProductPrice(int index, String value) {
    if (value.isNotEmpty) {
      selectedProductList[index]['price'] = value;
      setProductSubTotal(index, selectedProductList[index]['price'],
          selectedProductList[index]['quantity']);
      update();
    }
  }

  void setProductSubTotal(int index, String price, String quantity) {
    selectedProductList[index]['subtotal'] =
        int.parse(price) * int.parse(quantity);
    total.value = 0;
    for (var product in selectedProductList) {
      int subtotal = product['subtotal'];
      total.value += subtotal;
    }
    update();
  }

  void selectProductByType(TypeModel type) {
    selectedProductType.value = type;
    fetchProductsByType(productType: type);
    update();
  }

  void setSelectedProduct(ProductModel product) {
    selectedProduct.value = product;
    update();
  }

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductTypes();
    fetchProductsByType();
  }

  Future<String?> getLoggedInSalesName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<List<StoreModel>> fetchStores() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response =
          await http.get(Uri.parse("$baseUrl/api/stores/"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('login_token')!}',
      });
      if (response.statusCode == 200) {
        var json = response.body;
        stores = storeFromJson(json);
      } else {
        var json = response.body;
        log(json);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return stores;
  }

  Future<void> addStore(BuildContext context, bool mounted, String storeName,
      String address, String storeNumber) async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response =
          await http.post(Uri.parse("$baseUrl/api/stores/"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.getString('login_token')!}',
              },
              body: jsonEncode({
                'store_name': storeName,
                'address': address,
                'store_number': storeNumber,
              }));
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        var storeJson = jsonDecode(response.body);
        var store = StoreModel.fromJson(storeJson['data']);
        successMessage.value = "Berhasil menambahkan toko : ${store.storeName}";
      } else {
        log(response.body);
        errorMessage.value = json['message'].toString();
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    isLoading(false);
  }

  Future<List<TypeModel>> fetchProductTypes() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response =
          await http.get(Uri.parse("$baseUrl/api/product-type/"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('login_token')!}',
      });
      if (response.statusCode == 200) {
        var productJson = response.body;
        productTypes = typeFromJson(productJson);
        selectedProductType.value = productTypes[0];
        update();
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return productTypes;
  }

  void fetchProductsByType({
    TypeModel? productType,
  }) async {
    isLoading(true);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http.get(
          Uri.parse(
              "$baseUrl/api/product?type=${productType?.type == null ? '' : productType!.type}"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('login_token')!}',
          });
      if (response.statusCode == 200) {
        var productJson = response.body;
        products = productModelFromJson(productJson);
        update();
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    isLoading(false);
  }

  Future<void> checkoutOrder(BuildContext context, bool mounted) async {
    Map<String, dynamic> products = {};
    selectedProductList.asMap().forEach((index, item) {
      ProductModel product = item['product'];
      products["$index"] = {
        "product_id": product.id,
        "quantity": item["quantity"],
        "price": item["price"],
      };
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response =
          await http.post(Uri.parse("$baseUrl/api/transaction"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.getString('login_token')!}',
              },
              body: jsonEncode({
                "grand_total": total.value,
                "store_id": selectedStore.value!.id,
                "payment_method": "cash",
                "status": "unpaid",
                "detail": products,
              }));
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        // var transaction = TransactionModel.fromJson(json['data']);
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const SuccessPage(successType: SuccessType.transaction),
            ));
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        buildAlertSnackBar(
            context, "Terjadi masalah. Error : ${response.body}");
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
