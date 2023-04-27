import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/pages/payment/payment_controller.dart';
import 'package:get/get.dart';

class ReturnPage extends StatefulWidget {
  const ReturnPage({super.key, required this.transactionDetailId});

  final int transactionDetailId;

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  final PaymentController paymentController = Get.put(PaymentController());

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController desccriptionController = TextEditingController();

  var addReturnFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: CustomPadding.mediumPadding),
          child: Form(
            key: addReturnFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: CustomPadding.largePadding),
                    padding: EdgeInsets.all(CustomPadding.smallPadding),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.surface),
                    child: Icon(
                      Icons.refresh,
                      size: 96,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Text("Keterangan",
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: CustomPadding.smallPadding),
                TextFormField(
                  controller: desccriptionController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Keterangan wajib diisi.';
                    }
                    return null;
                  },
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w400),
                  maxLines: 9,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    errorStyle: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.only(
                        left: CustomPadding.mediumPadding,
                        top: CustomPadding.largePadding),
                    hintText: "Masukkan keterangan pengembalian",
                    hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: CustomPadding.mediumPadding),
                Text("Jumlah", style: Theme.of(context).textTheme.headline6),
                SizedBox(height: CustomPadding.smallPadding),
                TextFormField(
                  controller: quantityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah wajib diisi.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    errorStyle: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        EdgeInsets.only(left: CustomPadding.mediumPadding),
                    hintText: "Masukkan jumlah pengembalian",
                    hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: CustomPadding.mediumPadding),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (addReturnFormKey.currentState!.validate()) {
                        buildLoadingDialog(context);
                        await paymentController.productReturn(
                            transactionDetailId: widget.transactionDetailId,
                            returnQuantity: quantityController.text,
                            returnDescription: desccriptionController.text,
                            context: context,
                            mounted: mounted);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: CustomPadding.largePadding,
                            vertical: CustomPadding.extraSmallPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: Text(
                      "Return",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
