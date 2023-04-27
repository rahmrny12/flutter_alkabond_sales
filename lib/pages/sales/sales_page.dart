import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
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
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Konfirmasi",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary)),
              content: Text("Yakin ingin membatalkan transaksi?",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary)),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary))),
                    child: Text(
                      "Batal",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    )),
                ElevatedButton(
                  child: Text("Tutup",
                      style: Theme.of(context).textTheme.headline6),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          },
        );
        return result;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Transaksi'),
        ),
        body: GetBuilder<SalesController>(builder: (controller) {
          return StepIndicatorPageView(
              physics: const NeverScrollableScrollPhysics(),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              steps: 3,
              iconColor: Theme.of(context).colorScheme.secondary,
              activeLineColor: Theme.of(context).colorScheme.secondary,
              activeNodeColor: Theme.of(context).colorScheme.secondary,
              activeLabelStyle: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
              inActiveLabelStyle: Theme.of(context).textTheme.headline6,
              activeBorderColor: Theme.of(context).colorScheme.secondary,
              indicatorPosition: IndicatorPosition.top,
              labels: const ['Toko', 'Checkout', 'Detail'],
              controller: _pageController,
              children: [
                ChooseStore(pageController: _pageController),
                ChooseProducts(pageController: _pageController),
                Checkout(pageController: _pageController)
              ]);
        }),
      ),
    );
  }
}
