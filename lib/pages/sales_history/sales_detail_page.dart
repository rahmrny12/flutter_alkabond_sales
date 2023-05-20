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
import 'package:flutter_alkabond_sales/pages/payment/payment_controller.dart';
import 'package:flutter_alkabond_sales/pages/payment/return_page.dart';
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
  final PaymentController paymentController = Get.put(PaymentController());

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

                late String paymentStatus;
                switch (transaction?.status) {
                  case "paid":
                    paymentStatus = "Sudah Lunas";
                    break;
                  case "partial":
                    paymentStatus = "Dalam Cicilan";
                    break;
                  default:
                    paymentStatus = "Belum Dibayar";
                }

                late String deliveryStatus;
                switch (transaction?.deliveryStatus) {
                  case "sent":
                    deliveryStatus = "Sudah Dikirim";
                    break;
                  case "proccess":
                    deliveryStatus = "Sedang Diproses";
                    break;
                  default:
                    deliveryStatus = "Belum Dikirim";
                }

                if (transaction != null) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: CustomPadding.mediumPadding,
                              horizontal: CustomPadding.largePadding),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                    (widget.type == HistoryType.process)
                                        ? "Pesanan sedang di proses"
                                        : (widget.type == HistoryType.sent)
                                            ? "Pesanan sedang dikirim ke alamat toko tujuan"
                                            : (widget.type == HistoryType.tempo)
                                                ? "Pesanan sedang dalam cicilan"
                                                : "Pesanan telah selesai",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                              ),
                              SizedBox(width: CustomPadding.mediumPadding),
                              Image.asset(
                                (widget.type == HistoryType.process)
                                    ? "$imagePath/onprocess.png"
                                    : (widget.type == HistoryType.sent)
                                        ? "$imagePath/onsent.png"
                                        : (widget.type == HistoryType.tempo)
                                            ? "$imagePath/ontempo.png"
                                            : "$imagePath/done.png",
                                height: 70,
                              )
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
                              Image.asset(
                                "$imagePath/icon/location.png",
                                height: 18,
                              ),
                              SizedBox(width: CustomPadding.smallPadding),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      height: CustomPadding.extraSmallPadding),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                        "${transaction.storeName} - ${transaction.address}",
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
                              Image.asset(
                                "$imagePath/icon/user.png",
                                height: 18,
                              ),
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
                                  SizedBox(
                                      height: CustomPadding.extraSmallPadding),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        transaction.invoiceCode,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: CustomPadding.smallPadding),
                                  ...List.generate(
                                      transaction.transactionDetails.length,
                                      (index) => buildDetailProductCard(
                                          context,
                                          transaction.transactionDetails[index],
                                          transaction.deliveryStatus,
                                          transaction.status))
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: CustomPadding.smallPadding),
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: CustomPadding.smallPadding),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "$imagePath/icon/credit-card.png",
                                      height: 18,
                                    ),
                                    SizedBox(width: CustomPadding.smallPadding),
                                    Text(
                                        "Metode pembayaran : ${transaction.paymentMethod ?? '-'}",
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
                                padding: EdgeInsets.symmetric(
                                    vertical: CustomPadding.smallPadding),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "$imagePath/icon/dollar.png",
                                      height: 18,
                                    ),
                                    SizedBox(width: CustomPadding.smallPadding),
                                    RichText(
                                      text: TextSpan(
                                          text: "Status pembayaran : ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary),
                                          children: [
                                            TextSpan(text: paymentStatus)
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: CustomPadding.smallPadding),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "$imagePath/icon/truck.png",
                                      height: 18,
                                    ),
                                    SizedBox(width: CustomPadding.smallPadding),
                                    RichText(
                                      text: TextSpan(
                                          text: "Status pengiriman : ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary),
                                          children: [
                                            TextSpan(text: deliveryStatus)
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: CustomPadding.smallPadding),
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
                                      transaction.transactionDetails.length,
                                      (index) => buildSubtotal(
                                          context,
                                          transaction
                                              .transactionDetails[index])),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            CustomPadding.extraSmallPadding),
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
                                                      color: Theme.of(context)
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
                        SizedBox(height: CustomPadding.smallPadding),
                        if (widget.type.name != "process")
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: CustomPadding.largePadding),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PayTempoPage(
                                                transactionId:
                                                    widget.transactionId,
                                                remainingPay:
                                                    transaction.remainingPay,
                                                type: widget.type,
                                                payments: transaction.payments,
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
                                        width: CustomPadding.extraSmallPadding),
                                    Image.asset(
                                      "$imagePath/icon/file-text.png",
                                      height: 18,
                                    ),
                                  ],
                                )),
                          ),
                        // SizedBox(height: CustomPadding.extraSmallPadding),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: CustomPadding.largePadding),
                        //   child: ElevatedButton(
                        //       onPressed: () {
                        //         Get.toNamed("/return");
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //           backgroundColor: Theme.of(context)
                        //               .colorScheme
                        //               .surface,
                        //           padding: EdgeInsets.symmetric(
                        //               vertical:
                        //                   CustomPadding.smallPadding)),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             "Return",
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .headline5!
                        //                 .copyWith(
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .onSecondary),
                        //           ),
                        //           SizedBox(
                        //               width: CustomPadding
                        //                   .extraSmallPadding),
                        //           Icon(Icons.refresh,
                        //               color: Theme.of(context)
                        //                   .colorScheme
                        //                   .primary),
                        //         ],
                        //       )),
                        // ),ustomPadding.mediumPadding),
                        SizedBox(height: CustomPadding.extraLargePadding),
                      ],
                    ),
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

  Widget buildDetailProductCard(BuildContext context, TransactionDetail detail,
      String deliveryStatus, String paymentStatus) {
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
            detail.productCode,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "${detail.productName} - ${detail.productBrand} - ${detail.unitWeight}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "Jumlah : ${detail.quantity}x",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          SizedBox(height: CustomPadding.extraSmallPadding),
          Text(
            "Harga : ${parseToRupiah(detail.price)}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          if (deliveryStatus == "sent" && paymentStatus != "paid")
            (detail.returns?.id == null)
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: CustomPadding.smallPadding),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReturnPage(
                                    transactionDetailType: widget.type,
                                    transactionDetailId: detail.id,
                                  ),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              textStyle: Theme.of(context).textTheme.headline6,
                              padding: EdgeInsets.symmetric(
                                  vertical: CustomPadding.extraSmallPadding,
                                  horizontal: CustomPadding.largePadding),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text("Return")),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: CustomPadding.mediumPadding),
                      Text(
                        "Return",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      Text(
                        "Keterangan return :",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      Text(
                        detail.returns?.descriptionReturn ?? "-",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      SizedBox(height: CustomPadding.smallPadding),
                      Text(
                        "Jumlah return :",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      Text(
                        "${detail.returns?.returnsReturn ?? "-"} Barang",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: CustomPadding.smallPadding),
                            child: ElevatedButton(
                                onPressed: () {
                                  showConfirmationDialog(
                                    context: context,
                                    text: "Yakin ingin membatalkan return?",
                                    onPressed: () async {
                                      buildLoadingDialog(context);
                                      await paymentController.cancelReturn(
                                          transactionDetailId: detail.id,
                                          context: context,
                                          mounted: mounted);
                                      if (!mounted) return;
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SalesDetail(
                                                  type: widget.type,
                                                  transactionId:
                                                      widget.transactionId)));
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            CustomPadding.extraSmallPadding,
                                        horizontal: CustomPadding.largePadding),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text(
                                  "Batal Return",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                ))),
                      )
                    ],
                  )
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
