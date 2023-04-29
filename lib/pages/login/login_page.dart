import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/user_model.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_page.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:flutter_alkabond_sales/pages/login/login_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.find<LoginController>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> loginFormKey = GlobalKey();

  loginUser(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      try {
        controller.updateIsLoading(true);
        http.Response response =
            await http.post(Uri.parse('$baseUrl/api/login'), body: {
          'email': usernameController.text,
          'password': passwordController.text,
        });
        var json = jsonDecode(response.body);
        if (response.statusCode == 200 && json['status_code'] == 200) {
          UserModel user = userModelFromJson(response.body);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login_token', user.accessToken);
          prefs.setInt('id', user.data.id);
          prefs.setString('username', user.data.username);
          prefs.setString('email', user.data.email);
          prefs.setString('name', user.data.salesName);
          prefs.setString('phone_number', user.data.phoneNumber);
          prefs.setString('city', user.data.city);
          Get.toNamed('/home');
        } else {
          throw Exception(
              "Login gagal. Cek kembali username dan password Anda");
        }
      } catch (e) {
        buildAlertSnackBar(context, "Terjadi masalah. Error : $e");
        log("Login gagal. Error : ${e.toString()}");
      } finally {
        controller.updateIsLoading(false);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Image.asset(
                      "$imagePath/blob-login.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Column(
                    children: [
                      Spacer(flex: 2),
                      Image.asset(
                        "$imagePath/logo.png",
                        width: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          "Sejahtera Bersama",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: loginFormKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Sign In",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                    Container(
                                      width: 130,
                                      height: 5,
                                      margin:
                                          EdgeInsets.only(top: 12, bottom: 24),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ],
                                ),
                              ),
                              buildLoginInput(
                                  context: context,
                                  hint: "username",
                                  controller: usernameController,
                                  icon: "$imagePath/icon/username.png",
                                  isPassword: false),
                              buildLoginInput(
                                  context: context,
                                  hint: "password",
                                  controller: passwordController,
                                  icon: "$imagePath/icon/password.png",
                                  isPassword: true),
                              GetBuilder<LoginController>(
                                  builder: (controller) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 36),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.isDataLoading.value)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  CustomPadding.mediumPadding),
                                          child: CircularProgressIndicator(),
                                        ),
                                      ElevatedButton(
                                        onPressed:
                                            controller.isDataLoading.value
                                                ? null
                                                : () {
                                                    loginUser(context);
                                                  },
                                        style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24))),
                                            padding: MaterialStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 48))),
                                        child: Text(
                                          'LOGIN',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLoginInput(
      {required BuildContext context,
      required String hint,
      required TextEditingController controller,
      required String icon,
      required bool isPassword}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint wajib diisi.';
          }
          return null;
        },
        textInputAction:
            (isPassword) ? TextInputAction.done : TextInputAction.next,
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        decoration: InputDecoration(
            filled: true,
            fillColor:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            prefixIcon: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: CustomPadding.mediumPadding),
              child: Image.asset(icon),
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 24),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Theme.of(context).colorScheme.onPrimary),
              borderRadius: BorderRadius.circular(30),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.none),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: "Masukkan $hint...",
            hintStyle: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}
