import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:flutter_alkabond_sales/pages/login/login_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_controller.dart';
import 'package:get/get.dart';

class SalesHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesHistoryController>(() => SalesHistoryController());
  }
}
