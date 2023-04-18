import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
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

  loginUser(BuildContext context) async {
    try {
      controller.updateIsLoading(true);
      http.Response response =
          await http.post(Uri.tryParse('$baseUrl/api/login')!, body: {
        'email': usernameController.text,
        'password': passwordController.text,
      });
      var result = jsonDecode(response.body);
      UserModel user = UserModel.fromJson(result);
      if (response.statusCode == 200) {
        log(user.message.toString());
        Get.toNamed('/home');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('login_token', user.accessToken!);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text("Login gagal. Pesan : ${user.message}",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ));
        log(response.body);
      }
    } catch (e) {
      log("Error : $e");
    } finally {
      controller.updateIsLoading(false);
    }
  }

  @override
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
                      "assets/img/blob-login.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Column(
                    children: [
                      Spacer(),
                      Image.asset(
                        "assets/img/logo.png",
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
                                hint: "Masukkan username...",
                                controller: usernameController,
                                isPassword: false),
                            buildLoginInput(
                                context: context,
                                hint: "Masukkan password...",
                                controller: passwordController,
                                isPassword: true),
                            GetBuilder<LoginController>(builder: (controller) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 36),
                                child: ElevatedButton(
                                  onPressed: controller.isDataLoading.value
                                      ? null
                                      : () {
                                          loginUser(context);
                                        },
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24))),
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 48))),
                                  child: controller.isDataLoading.value
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('LOGIN'),
                                            Container(
                                              width: 24,
                                              height: 24,
                                              padding: const EdgeInsets.all(2),
                                              margin: const EdgeInsets.only(
                                                  left: 12),
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text('LOGIN'),
                                ),
                              );
                            })
                          ],
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

  TextField buildLoginInput(
      {required BuildContext context,
      required String hint,
      required TextEditingController controller,
      required bool isPassword}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.background,
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          )),
    );
  }
}
