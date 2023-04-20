import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/model/transaction_detail_model.dart';
import 'package:flutter_alkabond_sales/model/transaction_model.dart';
import 'package:flutter_alkabond_sales/pages/payment/pay_tempo_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_page.dart';
import 'package:get/get.dart';

class SalesDetail extends StatefulWidget {
  const SalesDetail(
      {super.key, required this.type, required this.transactionId});

  final HistoryType type;
  final int transactionId;

  @override
  State<SalesDetail> createState() => _SalesDetailState();
}

class _SalesDetailState extends State<SalesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: Text("Detail Transaksi"),
      ),
      body:
          GetBuilder<SalesHistoryController>(builder: (salesHistoryController) {
        return FutureBuilder<TransactionModel?>(
            future: salesHistoryController
                .fetchTransactionDetail(widget.transactionId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                TransactionModel? transaction = snap.data;
                if (transaction != null) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: CustomPadding.extraSmallPadding),
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
                                  Image.asset("$imagePath/icon/location.png"),
                                  SizedBox(width: CustomPadding.smallPadding),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Alamat Toko",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary)),
                                      SizedBox(
                                          height:
                                              CustomPadding.extraSmallPadding),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(transaction.address,
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
                              margin: EdgeInsets.only(
                                  bottom: CustomPadding.extraSmallPadding),
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
                                  Image.asset("$imagePath/icon/user.png"),
                                  SizedBox(width: CustomPadding.smallPadding),
                                  Text("Sales : ${transaction.salesName}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: CustomPadding.extraSmallPadding),
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
                                  Image.asset("$imagePath/icon/edit.png"),
                                  SizedBox(width: CustomPadding.smallPadding),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Rincian Pemesanan",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary)),
                                      SizedBox(
                                          height:
                                              CustomPadding.extraSmallPadding),
                                      SizedBox(
                                          height: CustomPadding.smallPadding),
                                      ...List.generate(
                                          transaction.transactionDetails.length,
                                          (index) => buildDetailProductCard(
                                              context,
                                              transaction
                                                  .transactionDetails[index]))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: CustomPadding.extraSmallPadding),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                          "$imagePath/icon/file-text.png"),
                                      SizedBox(
                                          width: CustomPadding.smallPadding),
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
                                  SizedBox(
                                      height: CustomPadding.extraSmallPadding),
                                  Column(
                                    children: [
                                      ...List.generate(
                                          transaction.transactionDetails.length,
                                          (index) => buildSubtotal(
                                              context,
                                              transaction
                                                  .transactionDetails[index])),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: CustomPadding
                                                .extraSmallPadding),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text("Total Pembayaran",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onSecondary)),
                                            ),
                                            Text(
                                                parseToRupiah(
                                                    transaction.grandTotal),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
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
                            SizedBox(height: CustomPadding.smallPadding),
                            if (widget.type.name != "process")
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: CustomPadding.largePadding),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PayTempoPage(
                                                          transactionId: widget
                                                              .transactionId)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            padding: EdgeInsets.symmetric(
                                                vertical: CustomPadding
                                                    .smallPadding)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Cicilan Barang",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary),
                                            ),
                                            SizedBox(
                                                width: CustomPadding
                                                    .extraSmallPadding),
                                            Image.asset(
                                                "$imagePath/icon/file-text.png"),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                      height: CustomPadding.extraSmallPadding),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: CustomPadding.largePadding),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed("/return");
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            padding: EdgeInsets.symmetric(
                                                vertical: CustomPadding
                                                    .smallPadding)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Return",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary),
                                            ),
                                            SizedBox(
                                                width: CustomPadding
                                                    .extraSmallPadding),
                                            Icon(Icons.refresh,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                      height: CustomPadding.extraLargePadding),
                                ],
                              ),
                            SizedBox(height: CustomPadding.mediumPadding),
                          ],
                        ),
                      ),
                      if (widget.type.name == "onsent" ||
                          widget.type.name == "tempo")
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: CustomPadding.mediumPadding,
                                vertical: CustomPadding.extraSmallPadding),
                            child: (transaction.deliveryStatus == "sent")
                                ? const SizedBox()
                                : ElevatedButton(
                                    onPressed: () async {
                                      buildLoadingDialog(context);
                                      var result = await salesHistoryController
                                          .confirmDeliverySuccess(
                                              context, transaction.id);
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      if (result) {
                                        if (!mounted) return;
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    SalesDetail(
                                                        type: widget.type,
                                                        transactionId: widget
                                                            .transactionId)));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                CustomPadding.smallPadding)),
                                    child: Text(
                                      "Pesanan Diterima",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    )),
                          ),
                        )
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Terjadi masalah.",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        ),
                        SizedBox(
                          height: CustomPadding.mediumPadding,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CustomPadding.largePadding),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SalesDetail(
                                              type: widget.type,
                                              transactionId:
                                                  widget.transactionId,
                                            )));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  padding: EdgeInsets.symmetric(
                                      vertical: CustomPadding.smallPadding)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Refresh ulang",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                  ),
                                  SizedBox(
                                      width: CustomPadding.extraSmallPadding),
                                  Icon(Icons.refresh,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ],
                              )),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      }),
    );
  }

  Widget buildDetailProductCard(
      BuildContext context, TransactionDetail product) {
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
            "Jumlah : ${product.quantity}x",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "Harga : ${parseToRupiah(product.price)}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],
      ),
    );
  }

  Widget buildSubtotal(BuildContext context, TransactionDetail detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: CustomPadding.extraSmallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
                "Subtotal untuk ${detail.productName} - ${detail.productBrand} - ${detail.unitWeight}",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary)),
          ),
          Text(parseToRupiah(detail.subtotal),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
        ],
      ),
    );
  }
}
