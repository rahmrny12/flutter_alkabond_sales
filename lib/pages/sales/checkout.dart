import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:flutter_alkabond_sales/pages/success_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(builder: (salesController) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: CustomPadding.extraSmallPadding),
              padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.mediumPadding,
                  vertical: CustomPadding.smallPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "$imagePath/icon/location.png",
                    height: 18,
                  ),
                  SizedBox(width: CustomPadding.smallPadding),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Keterangan Toko",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                      SizedBox(height: CustomPadding.extraSmallPadding),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                            "${salesController.selectedStore.value!.storeName} - ${salesController.selectedStore.value!.address}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: CustomPadding.extraSmallPadding),
              padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.mediumPadding,
                  vertical: CustomPadding.smallPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "$imagePath/icon/user.png",
                    height: 18,
                  ),
                  SizedBox(width: CustomPadding.smallPadding),
                  FutureBuilder<String?>(
                      future: salesController.getLoggedInSalesName(),
                      builder: (context, snap) {
                        String salesName = snap.data ?? "-";
                        return Text("Sales : $salesName",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary));
                      }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: CustomPadding.extraSmallPadding),
              padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.mediumPadding,
                  vertical: CustomPadding.smallPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "$imagePath/icon/edit.png",
                    height: 18,
                  ),
                  SizedBox(width: CustomPadding.smallPadding),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rincian Pemesanan",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                      SizedBox(height: CustomPadding.extraSmallPadding),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Text(
                      //     "INV20230410000001",
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .headline6!
                      //         .copyWith(
                      //             color:
                      //                 Theme.of(context).colorScheme.onSecondary,
                      //             fontWeight: FontWeight.w700),
                      //   ),
                      // ),
                      SizedBox(height: CustomPadding.smallPadding),
                      ...List.generate(
                        salesController.selectedProductList.length,
                        (index) => buildDetailProductCard(context,
                            salesController.selectedProductList[index]),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: CustomPadding.extraSmallPadding),
              padding: EdgeInsets.symmetric(
                  horizontal: CustomPadding.mediumPadding,
                  vertical: CustomPadding.smallPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "$imagePath/icon/file-text.png",
                        height: 18,
                      ),
                      SizedBox(width: CustomPadding.smallPadding),
                      Text("Rincian Pembayaran",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary)),
                    ],
                  ),
                  SizedBox(height: CustomPadding.extraSmallPadding),
                  Column(
                    children: [
                      ...List.generate(
                        salesController.selectedProductList.length,
                        (index) => buildSubtotal(context,
                            salesController.selectedProductList[index]),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: CustomPadding.extraSmallPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text("Total Pembayaran",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary)),
                            ),
                            Text(parseToRupiah(salesController.total.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: CustomPadding.largePadding,
                    bottom: CustomPadding.mediumPadding),
                child: Row(
                  children: [
                    SizedBox(width: CustomPadding.largePadding),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.pageController.previousPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                          salesController.currentStep.value =
                              widget.pageController.page!.round();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                        child: Text("Kembali"),
                      ),
                    ),
                    SizedBox(width: CustomPadding.largePadding),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            widget.pageController.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                            salesController.currentStep.value =
                                widget.pageController.page!.round();

                            if (salesController.currentStep.value == 2) {
                              buildLoadingDialog(context);
                              await salesController.checkoutOrder(
                                  context, mounted);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Text("Checkout")),
                    ),
                    SizedBox(width: CustomPadding.largePadding),
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget buildSubtotal(
      BuildContext context, Map<String, dynamic> selectedProductList) {
    ProductModel product = selectedProductList['product'];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: CustomPadding.extraSmallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
                "Subtotal untuk ${product.productName} - ${product.productBrand} - ${product.unitWeight}",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary)),
          ),
          Text(parseToRupiah(selectedProductList['subtotal']),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
        ],
      ),
    );
  }

  Widget buildDetailProductCard(
      BuildContext context, Map<String, dynamic> selectedProductList) {
    ProductModel product = selectedProductList["product"];
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.only(bottom: CustomPadding.smallPadding),
      margin: EdgeInsets.only(bottom: CustomPadding.mediumPadding),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onSurface))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productCode,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "${product.productName} - ${product.productBrand} - ${product.unitWeight}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "Jumlah : ${selectedProductList['quantity']}x",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "Harga : ${parseToRupiah(int.parse(selectedProductList['price']))}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],
      ),
    );
  }
}
