import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_controller.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
