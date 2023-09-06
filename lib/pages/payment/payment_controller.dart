import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_detail_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_page.dart';
import 'package:flutter_alkabond_sales/pages/success_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {
  var totalPay = 0.obs;

  Future<void> storePayment({
    required int transactionId,
    required String totalPay,
    required BuildContext context,
    required bool mounted,
    required HistoryType type,
  }) async {
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
                "total_pay": rupiahStringToInt(totalPay),
              }));
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const SuccessPage(successType: SuccessType.payment),
            ));
        // if (result.containsKey("status_code") && result['status_code'] == 200) {
        //   if (!mounted) return;
        // } else if (result['status_code'] == 401 &&
        //     result['status'] == 'invalid') {
        //   if (!mounted) return;
        //   Navigator.pop(context);
        //   buildAlertSnackBar(context, "Jumlah pembayaran terlalu besar.");
        // } else {
        //   if (!mounted) return;
        //   Navigator.pop(context);
        //   buildAlertSnackBar(context, "Pembayaran sudah lunas.");
        // }
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
      if (!mounted) return;
      Navigator.pop(context);
      if (response.statusCode == 200 && json['status_code'] == 200) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const SuccessPage(successType: SuccessType.productreturn),
            ));
      } else if (json['status_code'] == 401) {
        if (!mounted) return;
        buildCustomToast("Jumlah return melebihi jumlah pembelian produk..!",
            MessageType.failed);
        log(response.body);
      } else {
        if (!mounted) return;
        buildCustomToast("Terjadi kesalahan. Produk telah direturn sebelumnya",
            MessageType.failed);
        log(response.body);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      buildCustomToast(
          "Terjadi kesalahan. ${e.toString()}", MessageType.failed);
      Navigator.pop(context);
      log(e.toString());
    }
  }

  Future cancelReturn(
      {required int transactionDetailId,
      required BuildContext context,
      required bool mounted}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.delete(
        Uri.parse(
            "$baseUrl/api/transaction-detail/$transactionDetailId/destroy"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('login_token')!}',
        });
    var json = jsonDecode(response.body);
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pop(context);
    if (response.statusCode == 200 && json['status_code'] == 200) {
      buildCustomToast("Return dibatalkan.", MessageType.success);
    } else {
      buildCustomToast("Terjadi masalah. Coba lagi nanti", MessageType.success);
      log(json);
    }
  }
}
