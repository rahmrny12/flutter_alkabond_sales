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
import 'package:shared_preferences/shared_preferences.dart';

class SalesHistoryController extends GetxController {
  var isLoading = false.obs;
  var grandTotal = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<TransactionModel>> fetchTransactions(filter) async {
    List<TransactionModel> transactions = [];
    try {
      isLoading(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http
          .get(Uri.parse("$baseUrl/api/transaction/filter/$filter"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('login_token')!}',
      });
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        transactions = transactionModelFromJson(json['data']);
      } else {
        log(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
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
