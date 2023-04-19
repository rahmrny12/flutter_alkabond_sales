import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/model/type_model.dart';
import 'package:flutter_alkabond_sales/pages/home/home_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/checkout.dart';
import 'package:flutter_alkabond_sales/pages/sales/choose_product.dart';
import 'package:flutter_alkabond_sales/pages/sales/choose_store.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:get/get.dart';
import 'package:linear_step_indicator/linear_step_indicator.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  // final SalesController _salesController = Get.put(SalesController());

  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Transaksi'),
      ),
      body: GetBuilder<SalesController>(builder: (controller) {
        return StepIndicatorPageView(
            physics: const NeverScrollableScrollPhysics(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            steps: 3,
            indicatorPosition: IndicatorPosition.top,
            labels: ['Toko', 'Checkout', 'Detail'],
            controller: _pageController,
            children: [
              ChooseStore(pageController: _pageController),
              ChooseProducts(pageController: _pageController),
              Checkout(pageController: _pageController)
            ]);
      }),
    );
  }
}
