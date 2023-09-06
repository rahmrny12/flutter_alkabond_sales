import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/helper/rupiah_input_formatter.dart';
import 'package:flutter_alkabond_sales/model/transaction_model.dart';
import 'package:flutter_alkabond_sales/pages/payment/payment_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_detail_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_binding.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_page.dart';
import 'package:flutter_alkabond_sales/pages/success_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PayTempoPage extends StatefulWidget {
  const PayTempoPage(
      {super.key,
      required this.transactionId,
      required this.remainingPay,
      required this.payments,
      required this.type});

  final int transactionId;
  final int remainingPay;
  final List<Payment> payments;
  final HistoryType type;

  @override
  State<PayTempoPage> createState() => _PayTempoPageState();
}

class _PayTempoPageState extends State<PayTempoPage> {
  final PaymentController paymentController = Get.put(PaymentController());
  final SalesHistoryController salesHistoryController =
      Get.put(SalesHistoryController());

  final TextEditingController totalPayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverPersistentHeader(delegate: TotalCard(widget.remainingPay)),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: CustomPadding.largePadding),
              (widget.type.name != "done")
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: CustomPadding.mediumPadding),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              RupiahInputFormatter(),
                            ],
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.w400),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                totalPayController.text = value;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: CustomPadding.smallPadding,
                                      right: CustomPadding.extraSmallPadding,
                                      bottom:
                                          CustomPadding.extraSmallPadding / 2,
                                    ),
                                    child: Text(
                                      'Pembayaran : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                    ),
                                  )
                                ],
                              ),
                              fillColor: Theme.of(context).colorScheme.surface,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )),
                              contentPadding: EdgeInsets.only(
                                  left: CustomPadding.mediumPadding),
                              hintText: "Masukkan nominal pembayaran",
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(height: CustomPadding.smallPadding),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: CustomPadding.mediumPadding),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (totalPayController.text.isNotEmpty ||
                                    int.parse(totalPayController.text) < 1000) {
                                  showConfirmationDialog(
                                    context: context,
                                    text:
                                        "Apakah nominal pembayaran sudah benar?",
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      buildLoadingDialog(context);
                                      await paymentController.storePayment(
                                          transactionId: widget.transactionId,
                                          type: widget.type,
                                          totalPay: totalPayController.text,
                                          context: context,
                                          mounted: mounted);
                                    },
                                  );
                                } else {
                                  buildAlertSnackBar(
                                      context, "Isi nominal pembayaran");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: CustomPadding.largePadding,
                                      vertical:
                                          CustomPadding.extraSmallPadding),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              child: Text(
                                "Bayar",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : buildPaymentDone(),
              SizedBox(height: CustomPadding.extraLargePadding),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: CustomPadding.mediumPadding),
                  child: Text(
                    "Riwayat Pembayaran",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              SizedBox(height: CustomPadding.extraSmallPadding),
              ...List.generate(
                widget.payments.length,
                (index) => buildPaymentHistory(context, widget.payments[index]),
              ),
              SizedBox(height: CustomPadding.extraLargePadding),
            ],
          ),
        )
      ],
    ));
  }

  Container buildPaymentHistory(BuildContext context, Payment payment) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: CustomPadding.extraSmallPadding,
          horizontal: CustomPadding.mediumPadding),
      padding: EdgeInsets.all(CustomPadding.smallPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Pembayaran",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
              SizedBox(height: CustomPadding.extraSmallPadding),
              Text(
                DateFormat("dd MMM yyyy").format(payment.createdAt),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          ),
          Text(
            "-${parseToRupiah(payment.totalPay)}",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentDone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: CustomPadding.mediumPadding),
      padding: EdgeInsets.all(CustomPadding.smallPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pembayaran Cicilan Sudah lunas",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Icon(
            Icons.done,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class TotalCard extends SliverPersistentHeaderDelegate {
  TotalCard(this.remainingPay);

  final int remainingPay;

  @override
  double get maxExtent => 260 + 100 / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appbarSize = 260 - shrinkOffset;
    final proportion = 2 - (260 / appbarSize);
    final percent = proportion < 0 || proportion > 1 ? 0 : proportion;
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text("Cicilan"),
          ),
          Positioned(
            bottom: -40,
            child: Opacity(
              opacity: percent.toDouble(),
              child: Column(
                children: [
                  Text(
                    "Jumlah yang harus dibayar",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: CustomPadding.mediumPadding),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 120,
                    padding: EdgeInsets.symmetric(
                        horizontal: CustomPadding.largePadding,
                        vertical: CustomPadding.mediumPadding),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          parseToRupiah(remainingPay),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        ),
                        SizedBox(height: CustomPadding.smallPadding),
                        Text(
                          "Total sisa jumlah cicilan",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
