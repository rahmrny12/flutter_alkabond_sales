import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_controller.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardController dashboardController = Get.put(DashboardController());

  late ScrollController _scrollController;
  static const kExpandedHeight = 200.0;
  bool isExpanded = false;
  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    dashboardController.checkEmail();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients &&
            _scrollController.offset > kExpandedHeight - kToolbarHeight) {
          setState(() {
            isExpanded = true;
          });
        } else {
          setState(() {
            isExpanded = false;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            automaticallyImplyLeading: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular((isExpanded) ? 0 : 20))),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Sejahtera",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Text(
                                "Bersama",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              SizedBox(height: CustomPadding.largePadding),
                            ],
                          ),
                          Image.asset(
                            "assets/img/logo.png",
                            width: 130,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: CustomPadding.mediumPadding,
                      bottom: CustomPadding.mediumPadding,
                      child: Row(
                        children: [
                          Image.asset(
                            "$imagePath/icon/map-pin.png",
                            height: 18,
                          ),
                          SizedBox(width: CustomPadding.extraSmallPadding),
                          Text(
                            _prefs?.getString("city") ?? "-",
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              title: isExpanded
                  ? Text("Sejahtera Bersama",
                      style: Theme.of(context).textTheme.headline5)
                  : null,
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: CustomPadding.largePadding,
                  vertical: CustomPadding.extraLargePadding),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(3, 3),
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.8),
                        blurRadius: 4,
                        spreadRadius: 1)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildDashboardCard(
                      context: context,
                      text: "Total\nTransaksi",
                      count: dashboardController.transactionCount.value),
                  buildDashboardCard(
                      context: context,
                      text: "Total Transaksi\nBulan ini",
                      count:
                          dashboardController.thisMonthTransactionCount.value),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildSecondDashboardCard(
                    context,
                    "$imagePath/icon/file-text-circle.png",
                    "Transaksi",
                    "Pre Order", () {
                  Get.toNamed('/sales');
                }),
                buildSecondDashboardCard(
                    context,
                    "$imagePath/icon/history-circle.png",
                    "Riwayat",
                    "Transaksi", () {
                  Get.toNamed('/sales-history');
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildSecondDashboardCard(BuildContext context, String icon,
      String text, String info, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(3, 3),
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary
                      .withOpacity(0.8),
                  blurRadius: 4,
                  spreadRadius: 1)
            ]),
        padding: EdgeInsets.symmetric(horizontal: CustomPadding.smallPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: CustomPadding.extraSmallPadding),
            Image.asset(
              icon,
              height: 45,
            ),
            SizedBox(height: CustomPadding.mediumPadding),
            Text(
              text,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: CustomPadding.extraSmallPadding / 2),
            Text(
              info,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Theme.of(context).colorScheme.secondary),
            ),
            SizedBox(height: CustomPadding.smallPadding),
          ],
        ),
      ),
    );
  }

  Container buildDashboardCard({
    required BuildContext context,
    required String text,
    required int count,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: CustomPadding.largePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
