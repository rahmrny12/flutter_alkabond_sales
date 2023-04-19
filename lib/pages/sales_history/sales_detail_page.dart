import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/model/transaction_detail_model.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_controller.dart';
import 'package:get/get.dart';

class SalesDetail extends StatelessWidget {
  const SalesDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        title: Text("Detail Transaksi"),
      ),
      body:
          GetBuilder<SalesHistoryController>(builder: (salesHistoryController) {
        String type = Get.parameters['type']!;
        return FutureBuilder<TransactionDetailModel?>(
            future: salesHistoryController.fetchTransactionDetail(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                TransactionDetailModel transactionDetail = snap.data!;
                return SingleChildScrollView(
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
                                  child: Text(transactionDetail.data.address,
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
                            Text("Sales : ${transactionDetail.data.salesName}",
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
                                SizedBox(height: CustomPadding.smallPadding),
                                ...List.generate(
                                    transactionDetail.subdata.length,
                                    (index) => buildDetailProductCard(context,
                                        transactionDetail.subdata[index]))
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset("$imagePath/icon/file-text.png"),
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
                                    transactionDetail.subdata.length,
                                    (index) => buildSubtotal(context,
                                        transactionDetail.subdata[index])),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          CustomPadding.extraSmallPadding),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
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
                                      Text(
                                          parseToRupiah(transactionDetail
                                              .data.grandTotal),
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
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      }),
    );
  }

  Widget buildDetailProductCard(BuildContext context, ProductDetail product) {
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

  Widget buildSubtotal(BuildContext context, ProductDetail product) {
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
          Text(parseToRupiah(product.subtotal),
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
        ],
      ),
    );
  }
}
