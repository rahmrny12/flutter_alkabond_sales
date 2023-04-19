import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/model/transaction_model.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_detail_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum HistoryType {
  process,
  onsent,
  tempo,
  done,
}

class SalesHistoryPage extends StatelessWidget {
  const SalesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final historyController = Get.put(SalesHistoryController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Riwayat"),
          bottom: TabBar(
              // unselectedLabelStyle: Theme.of(context)
              //     .textTheme
              //     .headline6!
              //     .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              labelStyle: Theme.of(context).textTheme.headline6,
              // labelPadding:
              //     EdgeInsets.symmetric(vertical: CustomPadding.smallPadding),
              indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  border: Border(
                      bottom: BorderSide(
                          width: 4,
                          color: Theme.of(context).colorScheme.secondary))),
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
              tabs: const [
                Tab(
                  text: "Proses",
                ),
                Tab(
                  text: "Dikirim",
                ),
                Tab(
                  text: "Cicilan",
                ),
                Tab(
                  text: "Selesai",
                ),
              ]),
        ),
        body: GetBuilder<SalesHistoryController>(
            builder: (salesHistoryController) {
          return TabBarView(
            children: [
              buildProcessHistory(salesHistoryController, context),
              buildOnSentHistory(salesHistoryController, context),
              buildTempoHistory(salesHistoryController, context),
              buildDoneHistory(salesHistoryController, context),
            ],
          );
        }),
      ),
    );
  }

  Widget buildDoneHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: salesHistoryController.fetchTransactions(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData) {
            List<TransactionModel> transactions = snap.data!;
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildHistoryCard(
                    context, HistoryType.process, transactions[index]);
              },
            );
          } else {
            return Text("Data riwayat kosong.");
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildTempoHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: salesHistoryController.fetchTransactions(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData) {
            List<TransactionModel> transactions = snap.data!;
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildHistoryCard(
                    context, HistoryType.process, transactions[index]);
              },
            );
          } else {
            return Text("Data riwayat kosong.");
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildOnSentHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: salesHistoryController.fetchTransactions(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData) {
            List<TransactionModel> transactions = snap.data!;
            return ListView.builder(
              itemBuilder: (context, index) {
                return buildHistoryCard(
                    context, HistoryType.process, transactions[index]);
              },
            );
          } else {
            return Text("Data riwayat kosong.");
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildProcessHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: salesHistoryController.fetchTransactions(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData) {
            List<TransactionModel> transactions = snap.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return buildHistoryCard(
                    context, HistoryType.process, transactions[index]);
              },
            );
          } else {
            return Text("Data riwayat kosong.");
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildHistoryCard(
      BuildContext context, HistoryType type, TransactionModel transaction) {
    return GestureDetector(
      onTap: (() => Get.toNamed("/sales-detail",
          arguments: true,
          parameters: {"invoice-code": transaction.invoiceCode})),
      child: Container(
        margin: EdgeInsets.all(CustomPadding.mediumPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          border: Border(
              left: BorderSide(
                  width: 8, color: Theme.of(context).colorScheme.primary)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(CustomPadding.smallPadding),
                child: Text(
                  transaction.invoiceCode,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding:
                  EdgeInsets.symmetric(horizontal: CustomPadding.smallPadding),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.onSurface))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(height: CustomPadding.extraSmallPadding),
                  Text(
                    "Jumlah : 3x",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(height: CustomPadding.extraSmallPadding),
                  Text(
                    "Harga : Rp 12.000",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: CustomPadding.smallPadding),
              padding:
                  EdgeInsets.symmetric(vertical: CustomPadding.smallPadding),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.onBackground),
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.onBackground))),
              child: Center(
                child: Text("Tampilkan produk",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground)),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: CustomPadding.smallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "2 produk",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      Text.rich(TextSpan(
                          text: "Total pesanan : ",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                                text: "Rp 36.000",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ])),
                    ],
                  ),
                  SizedBox(height: CustomPadding.smallPadding),
                  Text(
                    "${transaction.storeName} - ${transaction.address}",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(CustomPadding.smallPadding),
                child: Text(
                  DateFormat("dd-MMMM-yyyy").format(transaction.createdAt),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            if (type == HistoryType.onsent) buildOrderReceivedButton(context)
          ],
        ),
      ),
    );
  }

  Container buildOrderReceivedButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(CustomPadding.smallPadding, 0,
          CustomPadding.smallPadding, CustomPadding.smallPadding),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.primary))),
        child: Text("Pesanan Diterima",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }
}
