import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_page.dart';
import 'package:flutter_alkabond_sales/pages/success_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {
  var totalPay = 0.obs;

  Future<dynamic> storePayment(
      {required int transactionId,
      required BuildContext context,
      required bool mounted}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response =
          await http.post(Uri.parse("$baseUrl/api/transaction/$transactionId"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${prefs.getString('login_token')!}',
              },
              body: jsonEncode({
                "total_pay": totalPay.value,
              }));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return json;
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        buildAlertSnackBar(context, "Terjadi masalah. Coba lagi nanti.");
        log(response.body);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      buildAlertSnackBar(context, "Terjadi masalah. Coba lagi nanti.");
      log(e.toString());
    }
    return json;
  }

  Future<void> productReturn(
      {required int transactionDetailId,
      required String returnQuantity,
      required String returnDescription,
      required BuildContext context,
      required bool mounted}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await http.post(
          Uri.parse(
              "$baseUrl/api/transaction-detail/$transactionDetailId/return"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('login_token')!}',
          },
          body: jsonEncode({
            "return": returnQuantity,
            "description_return": returnDescription,
          }));
      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status_code'] == 200) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const SuccessPage(successType: SuccessType.productreturn),
              ));
        } else if (json['status_code'] == 401) {
          if (!mounted) return;
          Navigator.pop(context);
          buildAlertSnackBar(
              context, "Jumlah return melebihi jumlah pembelian produk..!");
          log(response.body);
        } else {
          if (!mounted) return;
          Navigator.pop(context);
          log(response.body);
        }
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        log(response.body);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      log(e.toString());
    }
  }
}
