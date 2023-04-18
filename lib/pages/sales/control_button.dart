import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';

Widget buildControlButton(BuildContext context, PageController pageController) {
  return Row(
    children: [
      SizedBox(width: CustomPadding.largePadding),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            pageController.previousPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      width: 2, color: Theme.of(context).colorScheme.primary))),
          child: Text("Kembali"),
        ),
      ),
      SizedBox(width: CustomPadding.largePadding),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            pageController.nextPage(
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Text("Selanjutnya"),
        ),
      ),
      SizedBox(width: CustomPadding.largePadding),
    ],
  );
}
