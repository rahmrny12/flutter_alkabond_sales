import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/model/transaction_model.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_detail_page.dart';
import 'package:flutter_alkabond_sales/pages/sales_history/sales_history_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum HistoryType {
  process,
  sent,
  tempo,
  done,
}

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  SalesHistoryController salesHistoryController =
      Get.put(SalesHistoryController());
  SalesController salesController = Get.put(SalesController());

  @override
  void dispose() {
    salesHistoryController.initDate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  // Tab(
                  //   text: "Proses",
                  // ),
                  // Tab(
                  //   text: "Dikirim",
                  // ),
                  // Tab(
                  //   text: "Cicilan",
                  // ),
                  Tab(
                    text: "Selesai",
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              // buildProcessHistory(salesHistoryController, context),
              // buildSentHistory(salesHistoryController, context),
              // buildTempoHistory(salesHistoryController, context),
              buildDoneHistory(salesHistoryController, context),
            ],
          )),
    );
  }

  Center buildErrorMessage(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            salesHistoryController.errorMessage.value ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          // SizedBox(
          //   height: CustomPadding.smallPadding,
          // ),
          // buildRefreshHistoryButton(context)
        ],
      ),
    ));
  }

  Widget buildFilterButton(BuildContext context, HistoryType filter) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: CustomPadding.smallPadding),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: () {
              buildFilterModal(context, filter);
            },
            child: Text(
              "Filter",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            )),
      ),
    );
  }

  Future<dynamic> buildFilterModal(BuildContext context, HistoryType filter) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 1,
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.7,
          builder: (context, scrollController) {
            return GetBuilder<SalesHistoryController>(builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: CustomPadding.largePadding,
                        bottom: CustomPadding.smallPadding,
                        left: CustomPadding.mediumPadding,
                        right: CustomPadding.mediumPadding,
                      ),
                      child: Text('Filter Transaksi',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black)),
                    ),
                    SizedBox(height: CustomPadding.mediumPadding),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: CustomPadding.mediumPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              margin: EdgeInsets.symmetric(
                                  vertical: CustomPadding.extraSmallPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tanggal awal",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontWeight: FontWeight.w400)),
                                  SizedBox(
                                      height: CustomPadding.smallPadding / 2),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                onPrimary: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary, // header text color
                                                onSurface: Colors
                                                    .black, // body text color
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      ).then((value) {
                                        if (value != null) {
                                          controller.from.value = value;
                                          controller.dateFromController.text =
                                              DateFormat("dd-MM-yyyy")
                                                  .format(value);
                                        }
                                      });
                                    },
                                    child: TextField(
                                      controller: controller.dateFromController,
                                      textInputAction: TextInputAction.next,
                                      enabled: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontWeight: FontWeight.w700),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(0.4),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        suffixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        contentPadding: EdgeInsets.only(
                                            left: CustomPadding.mediumPadding),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: CustomPadding.smallPadding),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              margin: EdgeInsets.symmetric(
                                  vertical: CustomPadding.extraSmallPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tanggal akhir",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontWeight: FontWeight.w400)),
                                  SizedBox(
                                      height: CustomPadding.smallPadding / 2),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                onPrimary: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary, // header text color
                                                onSurface: Colors
                                                    .black, // body text color
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      ).then((value) {
                                        if (value != null) {
                                          controller.to.value = value;
                                          controller.dateToController.text =
                                              DateFormat("dd-MM-yyyy")
                                                  .format(value);
                                        }
                                      });
                                    },
                                    child: TextField(
                                      controller: controller.dateToController,
                                      enabled: false,
                                      textInputAction: TextInputAction.next,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontWeight: FontWeight.w700),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(0.4),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        suffixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        contentPadding: EdgeInsets.only(
                                            left: CustomPadding.mediumPadding),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(CustomPadding.mediumPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pilih toko",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontWeight: FontWeight.w400)),
                          SizedBox(height: CustomPadding.smallPadding / 2),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DropdownSearch<StoreModel>(
                              popupProps: PopupProps.dialog(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.5,
                                  ),
                                  dialogProps: DialogProps(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.white),
                                  showSelectedItems: true,
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: Colors.white),
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: "Cari toko",
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.5),
                                      ))),
                              compareFn: (item1, item2) => item1.isEqual(item2),
                              // filterFn: (item, filter) =>
                              //     item.storeFilterByName(filter),
                              asyncItems: (text) =>
                                  salesController.fetchStores(),
                              itemAsString: (store) =>
                                  "${store.storeName} - ${store.address}",
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                baseStyle: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withOpacity(0.4),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  contentPadding: EdgeInsets.only(
                                      left: CustomPadding.mediumPadding),
                                ),
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: Icon(Icons.search,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                              dropdownBuilder:
                                  (BuildContext context, StoreModel? store) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: CustomPadding.extraSmallPadding / 2),
                                  child: Text(
                                      store == null
                                          ? "-"
                                          : "${store.storeName} - ${store.address}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary)),
                                );
                              },
                              onChanged: (value) {
                                salesController.selectedStore.value = value;
                                salesHistoryController.storeId.value =
                                    value?.id;
                              },
                              selectedItem: salesController.selectedStore.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: CustomPadding.largePadding),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: CustomPadding.mediumPadding),
                      padding: EdgeInsets.symmetric(
                          vertical: CustomPadding.smallPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        border: Border(
                            top: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                      width: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            child: Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              controller.fetchTransactions(filter.name);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const SalesHistoryPage()));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                fixedSize: Size(150, 45)),
                            child: Text("Filter"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }

  Widget buildDoneHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildFilterButton(context, HistoryType.done),
      FutureBuilder<List<TransactionModel>>(
        future: salesHistoryController.fetchTransactions(HistoryType.done.name),
        builder: (context, snap) {
          if (snap.hasData) {
            List<TransactionModel>? transactions = snap.data;
            if (transactions!.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      transactions.length,
                      (index) => buildHistoryCard(context, HistoryType.done,
                          transactions[index], salesHistoryController)),
                ],
              );
            } else {
              return Padding(
                  padding:
                      EdgeInsets.only(top: CustomPadding.extraLargePadding),
                  child: buildRefreshHistoryButton(context));
            }
          } else if (snap.hasError) {
            return SizedBox();
          } else {
            return Padding(
                padding: EdgeInsets.only(top: CustomPadding.extraLargePadding),
                child: Center(child: CircularProgressIndicator()));
          }
        },
      )
    ]));
  }

  Widget buildTempoHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildFilterButton(context, HistoryType.tempo),
      FutureBuilder<List<TransactionModel>>(
        future:
            salesHistoryController.fetchTransactions(HistoryType.tempo.name),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            List<TransactionModel>? transactions = snap.data;
            if (transactions!.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      transactions.length,
                      (index) => buildHistoryCard(context, HistoryType.tempo,
                          transactions[index], salesHistoryController)),
                ],
              );
            } else {
              return Padding(
                  padding:
                      EdgeInsets.only(top: CustomPadding.extraLargePadding),
                  child: buildRefreshHistoryButton(context));
            }
          } else if (snap.connectionState == ConnectionState.waiting) {
            return Padding(
                padding: EdgeInsets.only(top: CustomPadding.extraLargePadding),
                child: Center(child: CircularProgressIndicator()));
          } else if (snap.hasError) {
            return SizedBox();
          } else {
            return SizedBox();
          }
        },
      )
    ]));
  }

  Widget buildSentHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildFilterButton(context, HistoryType.sent),
      FutureBuilder<List<TransactionModel>>(
        future: salesHistoryController.fetchTransactions(HistoryType.sent.name),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            List<TransactionModel>? transactions = snap.data;
            if (transactions!.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      transactions.length,
                      (index) => buildHistoryCard(context, HistoryType.sent,
                          transactions[index], salesHistoryController)),
                ],
              );
            } else {
              return Padding(
                  padding:
                      EdgeInsets.only(top: CustomPadding.extraLargePadding),
                  child: buildRefreshHistoryButton(context));
            }
          } else if (snap.connectionState == ConnectionState.waiting) {
            return Padding(
                padding: EdgeInsets.only(top: CustomPadding.extraLargePadding),
                child: Center(child: CircularProgressIndicator()));
          } else if (snap.hasError) {
            return SizedBox();
          } else {
            return SizedBox();
          }
        },
      )
    ]));
  }

  Widget buildProcessHistory(
      SalesHistoryController salesHistoryController, BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildFilterButton(context, HistoryType.process),
      FutureBuilder<List<TransactionModel>>(
        future:
            salesHistoryController.fetchTransactions(HistoryType.process.name),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            List<TransactionModel>? transactions = snap.data;
            if (transactions!.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                      transactions.length,
                      (index) => buildHistoryCard(context, HistoryType.process,
                          transactions[index], salesHistoryController)),
                ],
              );
            } else {
              return Padding(
                  padding:
                      EdgeInsets.only(top: CustomPadding.extraLargePadding),
                  child: buildRefreshHistoryButton(context));
            }
          } else if (snap.connectionState == ConnectionState.waiting) {
            return Padding(
                padding: EdgeInsets.only(top: CustomPadding.extraLargePadding),
                child: Center(child: CircularProgressIndicator()));
          } else if (snap.hasError) {
            return SizedBox();
          } else {
            return SizedBox();
          }
        },
      )
    ]));
  }

  Padding buildRefreshHistoryButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
            child: Text(
              "Data riwayat kosong.",
              style: Theme.of(context).textTheme.headline4,
            ),
          )),
          SizedBox(height: CustomPadding.mediumPadding),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SalesHistoryPage()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  padding: EdgeInsets.symmetric(
                      vertical: CustomPadding.smallPadding)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Refresh ulang",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(width: CustomPadding.extraSmallPadding),
                  Icon(Icons.refresh,
                      color: Theme.of(context).colorScheme.primary),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildHistoryCard(
      BuildContext context,
      HistoryType type,
      TransactionModel transaction,
      SalesHistoryController salesHistoryController) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesDetail(
                type: type,
                transactionId: transaction.id,
              ),
            ));
      }),
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
                    "Produk : ${transaction.transactionDetails[0].productName} - ${transaction.transactionDetails[0].productBrand} - ${transaction.transactionDetails[0].unitWeight}",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(height: CustomPadding.extraSmallPadding),
                  Text(
                    "Jumlah : ${transaction.transactionDetails[0].quantity}",
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(height: CustomPadding.extraSmallPadding),
                  Text(
                    "Harga : ${parseToRupiah(transaction.transactionDetails[0].price)}",
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
                        "${transaction.transactionDetails.length} produk",
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
                                text: parseToRupiah(transaction.grandTotal),
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
            // if (type == HistoryType.sent)
            //   if (transaction.deliveryStatus != "sent")
            //     buildOrderReceivedButton(
            //         context, transaction, salesHistoryController)
          ],
        ),
      ),
    );
  }

  // Container buildOrderReceivedButton(
  //     BuildContext context,
  //     TransactionModel transaction,
  //     SalesHistoryController salesHistoryController) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.fromLTRB(CustomPadding.smallPadding, 0,
  //         CustomPadding.smallPadding, CustomPadding.smallPadding),
  //     child: ElevatedButton(
  //       onPressed: () async {
  //         buildLoadingDialog(context);
  //         var result = await salesHistoryController.confirmDeliverySuccess(
  //             context, transaction.id);
  //         if (!mounted) return;
  //         Navigator.pop(context);
  //         if (result) {
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (BuildContext context) => SalesHistoryPage()));
  //         } else {
  //           if (!mounted) return;
  //           buildAlertSnackBar(context, "Terjadi masalah. Coba lagi nanti.");
  //         }
  //       },
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Theme.of(context).colorScheme.onPrimary,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               side: BorderSide(
  //                   width: 2, color: Theme.of(context).colorScheme.primary))),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text("Pesanan Diterima",
  //               style: Theme.of(context).textTheme.headline5!.copyWith(
  //                     color: Theme.of(context).colorScheme.primary,
  //                   )),
  //           // if (transaction.deliveryStatus == "sent")
  //           //   Padding(
  //           //     padding: EdgeInsets.only(left: CustomPadding.extraSmallPadding),
  //           //     child: Icon(
  //           //       Icons.check_circle,
  //           //       color: Theme.of(context).colorScheme.onPrimary,
  //           //     ),
  //           //   )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  bool get wantKeepAlive => false;
}
