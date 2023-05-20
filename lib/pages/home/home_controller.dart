import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/pages/login/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var tabIndex = 0;

  changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
