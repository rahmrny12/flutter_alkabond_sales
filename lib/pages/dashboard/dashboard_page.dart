import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(0.8),
                    blurRadius: 4,
                    spreadRadius: 2)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildDashboardCard(context: context, text: "Riwayat", count: 55),
              buildDashboardCard(context: context, text: "Return", count: 11),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: CustomPadding.extraLargePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildSecondDashboardCard(context, "Transaksi", "Pre Order", () {
                Get.toNamed('/sales');
              }),
              buildSecondDashboardCard(context, "Riwayat", "Transaksi", () {
                Get.toNamed('/sales');
              }),
            ],
          ),
        )
      ],
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
                  offset: Offset(2, 2),
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary
                      .withOpacity(0.8),
                  blurRadius: 4,
                  spreadRadius: 2)
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
