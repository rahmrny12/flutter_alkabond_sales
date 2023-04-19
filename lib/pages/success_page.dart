import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:get/get.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(CustomPadding.mediumPadding),
              child: Image.asset("$imagePath/success.png"),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Transaksi Berhasil",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(height: CustomPadding.largePadding),
                  Text(
                    textAlign: TextAlign.center,
                    "Produk telah dipesan, klik riwayat untuk melihat detail produk",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: CustomPadding.largePadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: CustomPadding.smallPadding,
                                  horizontal: CustomPadding.largePadding),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide(
                                      width: 4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                          child: Text(
                            "Beranda",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed("/sales-history");
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: CustomPadding.smallPadding,
                                  horizontal: CustomPadding.largePadding),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide(
                                      width: 4,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                          child: Text(
                            "Riwayat",
                            style: Theme.of(context).textTheme.headline3,
                          ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
