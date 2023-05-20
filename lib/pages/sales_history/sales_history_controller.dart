import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/transaction_detail_model.dart';
import 'package:flutter_alkabond_sales/model/transaction_model.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesHistoryController extends GetxController {
  var isLoading = false.obs;
  var now = DateTime.now();
  // var grandTotal = Rxn<int>();
  var storeId = Rxn<int>();
  // default value
  var from = Rxn<DateTime>();
  var to = Rxn<DateTime>();

  var errorMessage = Rxn<String>();

  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();

  void initDate() {
    from.value = now.subtract(const Duration(days: 29));
    dateFromController.text = DateFormat("dd-MM-yyyy").format(from.value!);
    to.value = now;
    dateToController.text = DateFormat("dd-MM-yyyy").format(to.value!);
    storeId.value = null;
  }

  @override
  void onInit() {
    super.onInit();
    initDate();
  }

  Future<List<TransactionModel>> fetchTransactions(filter) async {
    List<TransactionModel> transactions = [];
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http.get(
          Uri.parse(
              "$baseUrl/api/transaction/al?filter=$filter&storeId=${storeId.value ?? ''}&from=${(from.value != null) ? DateFormat('yyyy-MM-dd').format(from.value!) : ''}&to=${(to.value != null) ? DateFormat('yyyy-MM-dd').format(to.value!) : ''}"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('login_token')!}',
          });
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        transactions = transactionModelFromJson(json['data']);
      } else {
        log(json.toString());
        throw Exception("Terjadi masalah. Coba lagi nanti.");
      }
    } on Exception catch (e) {
      buildCustomToast(
          "Terjadi kesalahan. ${e.toString()}", MessageType.success);
      throw Exception("Terjadi masalah. Coba lagi nanti.");
    } finally {
      isLoading(false);
    }
    return transactions;
  }

  Future<TransactionModel?> fetchTransactionDetail(int transactionId) async {
    TransactionModel? transaction;
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http
          .get(Uri.parse("$baseUrl/api/transaction/$transactionId"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('login_token')!}',
      });
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        transaction = TransactionModel.fromJson(json['data']);
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
    return transaction;
  }

  Future<bool> confirmDeliverySuccess(
      BuildContext context, int transactionId) async {
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http.post(
          Uri.parse("$baseUrl/api/transaction/$transactionId/confirm"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('login_token')!}',
          });
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        print(response.body);
        return true;
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    isLoading(false);
    return false;
  }
}
