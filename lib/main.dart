import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/pages/custom_theme.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_binding.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_page.dart';
import 'package:flutter_alkabond_sales/pages/home/home_binding.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:flutter_alkabond_sales/pages/home/home_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_binding.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penjualan Alkabond',
      theme: CustomTheme.light(),
      home: const HomePage(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardPage(),
          binding: DashboardBinding(),
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
      ],
    );
  }
}
