import 'dart:convert';
import 'dart:developer';

import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  var transactionCount = 0.obs;
  var thisMonthTransactionCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future fetchDashboard() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response =
          await http.get(Uri.parse("$baseUrl/api/dashboard/"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('login_token')!}',
      });
      if (response.statusCode == 200) {
        var productJson = jsonDecode(response.body);
        transactionCount.value = productJson['data']['transaction'];
        thisMonthTransactionCount.value =
            productJson['data']['this_month_transaction'];
      } else {
        throw Exception(response.body);
      }
    } on Exception catch (e) {
      log(e.toString());
      buildCustomToast("Gagal memuat data.", MessageType.failed);
    }
  }
}
