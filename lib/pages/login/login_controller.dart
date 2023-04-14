import 'dart:convert';
import 'dart:developer';

import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/model/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  UserModel? userModel;
  var isDataLoading = false.obs;

  void updateIsLoading(value) {
    isDataLoading.value = value;
    update();
  }
}
