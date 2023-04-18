import 'dart:convert';
import 'dart:developer';

import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/model/type_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';

class SalesController extends GetxController {
  List<StoreModel> stores = <StoreModel>[].obs;
  List<ProductModel> products = <ProductModel>[].obs;
  List<TypeModel> productTypes = <TypeModel>[].obs;

  Rxn<TypeModel> selectedProductType = Rxn<TypeModel>();
  Rxn<ProductModel> selectedProduct = Rxn<ProductModel>();

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
    fetchProductsByType();
  }

  Future<List<StoreModel>> fetchStores() async {
    try {
      isLoading(true);
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
    } finally {
      isLoading(false);
    }
    return stores;
  }

  Future<StoreModel?> addStore(
      String storeName, String address, String storeNumber) async {
    StoreModel? store;
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
      if (response.statusCode == 200) {
        var storeJson = jsonDecode(response.body);
        store = StoreModel.fromJson(storeJson['data']);
        log(store.storeName);
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
    return store;
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
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return productTypes;
  }

  Future<List<ProductModel>> fetchProductsByType({
    TypeModel? productType,
  }) async {
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
    return products;
  }
}
