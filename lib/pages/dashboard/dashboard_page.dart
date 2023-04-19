import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ScrollController _scrollController;
  static const kExpandedHeight = 200.0;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

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
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Center(
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
                        ],
                      ),
                      Image.asset(
                        "assets/img/logo.png",
                        width: 130,
                      ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              title: isExpanded
                  ? Text("Sejahtera Bersama",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ))
                  : null,
            ),
          ),
        ];
      },
      body: Column(
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
                    context: context, text: "Riwayat", count: 55),
                buildDashboardCard(context: context, text: "Return", count: 11),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildSecondDashboardCard(context, "Transaksi", "Pre Order", () {
                Get.toNamed('/sales');
              }),
              buildSecondDashboardCard(context, "Riwayat", "Transaksi", () {
                Get.toNamed('/sales-history');
              }),
            ],
          )
        ],
      ),
    );
  }

  GestureDetector buildSecondDashboardCard(
      BuildContext context, String text, String info, Function() onPressed) {
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
        padding: EdgeInsets.symmetric(
            vertical: CustomPadding.mediumPadding,
            horizontal: CustomPadding.smallPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 4),
            Text(
              info,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Theme.of(context).colorScheme.secondary),
            ),
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
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(height: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.headline3,
          ),
        ],
      ),
    );
  }
}
