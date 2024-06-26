import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/custom_theme.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_binding.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_page.dart';
import 'package:flutter_alkabond_sales/pages/home/home_binding.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:flutter_alkabond_sales/pages/home/home_page.dart';
import 'package:flutter_alkabond_sales/pages/login/login_binding.dart';
import 'package:flutter_alkabond_sales/pages/login/login_page.dart';
import 'package:flutter_alkabond_sales/pages/payment/pay_tempo_page.dart';
import 'package:flutter_alkabond_sales/pages/payment/return_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_binding.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_detail_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_binding.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_page.dart';
import 'package:flutter_alkabond_sales/pages/success_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');

  // SalesController controller = Get.put(SalesController());
  // var checkToken = await controller.fetchStores();
  // if (checkToken.isEmpty) {
  //   email == null;
  // }

  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penjualan Alkabond',
      theme: CustomTheme.light(),
      home: const HomePage(),
      initialRoute: email != null ? '/' : '/login',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardPage(),
          binding: DashboardBinding(),
        ),
        GetPage(
          name: '/sales',
          page: () => const SalesPage(),
          binding: SalesBinding(),
        ),
        GetPage(
          name: '/sales-history',
          page: () => const SalesHistoryPage(),
          binding: SalesHistoryBinding(),
        ),
        // GetPage(
        //   name: '/sales-detail',
        //   page: () => const SalesDetail(),
        // ),
        // GetPage(
        //   name: '/return',
        //   page: () => const ReturnPage(),
        // ),
      ],
    );
  }
}
