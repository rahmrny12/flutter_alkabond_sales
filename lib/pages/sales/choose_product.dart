import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/pages/sales/control_button.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../model/type_model.dart';

class ChooseProducts extends StatelessWidget {
  const ChooseProducts({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final formAddProductKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: GetBuilder<SalesController>(builder: (salesController) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40))),
                        builder: (context) {
                          return GetBuilder<SalesController>(
                              builder: (salesController) {
                            return DraggableScrollableSheet(
                              maxChildSize: 1,
                              expand: false,
                              initialChildSize: 0.9,
                              minChildSize: 0.9,
                              builder: (context, scrollController) {
                                return Form(
                                    key: formAddProductKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: CustomPadding.mediumPadding,
                                              bottom:
                                                  CustomPadding.smallPadding,
                                              left: CustomPadding.mediumPadding,
                                              right:
                                                  CustomPadding.mediumPadding,
                                            ),
                                            child: Text('Jenis Produk',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4!
                                                    .copyWith(
                                                        color: Colors.black)),
                                          ),
                                          FutureBuilder<List<TypeModel>>(
                                              future: salesController
                                                  .fetchProductTypes(),
                                              builder: (context, snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.done) {
                                                  List<TypeModel> types =
                                                      snap.data!;
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            CustomPadding
                                                                .mediumPadding),
                                                    child: Wrap(
                                                      spacing: CustomPadding
                                                          .extraSmallPadding,
                                                      children: [
                                                        ...List.generate(
                                                          snap.data!.length,
                                                          (index) =>
                                                              GestureDetector(
                                                            onTap: () {
                                                              salesController
                                                                  .selectProductByType(
                                                                      types[
                                                                          index]);
                                                            },
                                                            child: buildFilterProductType(
                                                                context,
                                                                types[index]
                                                                    .type,
                                                                types[index].id,
                                                                salesController),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: CustomPadding
                                                              .mediumPadding),
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              }),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top:
                                                    CustomPadding.mediumPadding,
                                                bottom:
                                                    CustomPadding.smallPadding,
                                                left:
                                                    CustomPadding.mediumPadding,
                                                right: CustomPadding
                                                    .mediumPadding),
                                            child: Text('Produk',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4!
                                                    .copyWith(
                                                        color: Colors.black)),
                                          ),
                                          ...List.generate(
                                              salesController.products.length,
                                              (index) => RadioListTile<int>(
                                                  title: Text(
                                                      "${salesController.products[index].productName} - ${salesController.products[index].productBrand} - ${salesController.products[index].unitWeight}"),
                                                  value: salesController
                                                      .products[index].id,
                                                  groupValue: salesController
                                                          .selectedProduct
                                                          .value
                                                          ?.id ??
                                                      1,
                                                  onChanged: (value) =>
                                                      salesController
                                                          .setSelectedProduct(
                                                              salesController
                                                                      .products[
                                                                  index]))),
                                          SizedBox(
                                              height:
                                                  CustomPadding.mediumPadding),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: CustomPadding
                                                    .mediumPadding),
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    CustomPadding.smallPadding),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize: Size(150, 45),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                            side: BorderSide(
                                                                width: 2,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary)),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                    foregroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                  ),
                                                  child: Text("Batal"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    salesController
                                                        .addProductToSale();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                          ),
                                                          fixedSize:
                                                              Size(150, 45)),
                                                  child: Text("Tambah"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            );
                          });
                        },
                      );
                    },
                    child: const Text("Tambah Produk"))),
            ...List.generate(
              salesController.selectedProductList.length,
              (index) => buildProductCard(context, salesController, index),
            ),
            if (salesController.selectedProductList.isNotEmpty)
              buildTotalPaymentCard(context, salesController),
            SizedBox(height: CustomPadding.mediumPadding),
            Padding(
              padding: EdgeInsets.only(bottom: CustomPadding.largePadding),
              child: buildControlButton(context, pageController),
            ),
          ],
        );
      }),
    );
  }

  Container buildTotalPaymentCard(
      BuildContext context, SalesController salesController) {
    return Container(
      padding: EdgeInsets.all(CustomPadding.mediumPadding),
      margin: EdgeInsets.all(CustomPadding.smallPadding),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total Bayar",
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSecondary)),
          Text(salesController.total.value.toString(),
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSecondary)),
        ],
      ),
    );
  }

  Chip buildFilterProductType(BuildContext context, String label, int id,
      SalesController salesController) {
    return Chip(
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.headline6!.copyWith(
            color: salesController.selectedProductType.value?.id == id
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary,
          ),
      backgroundColor: salesController.selectedProductType.value?.id == id
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.primary)),
    );
  }

  Widget buildProductCard(
      BuildContext context, SalesController salesController, int index) {
    return Container(
      padding: EdgeInsets.all(CustomPadding.mediumPadding),
      margin: EdgeInsets.all(CustomPadding.smallPadding),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: CustomPadding.extraSmallPadding),
                child: Text('PKG202304100001',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary)),
              )),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildProductCardText(
                context: context,
                index: index,
                label: "Produk",
                value:
                    "${salesController.selectedProductList[index]['product'].productName} - ${salesController.selectedProductList[index]['product'].productBrand} - ${salesController.selectedProductList[index]['product'].unitWeight}",
              ),
              buildProductCardText(
                context: context,
                index: index,
                label: "Produk",
                updateValue: (p0, p1) =>
                    salesController.setProductPrice(p0, p1),
              ),
              buildProductCardText(
                context: context,
                index: index,
                label: "Jumlah",
                updateValue: (p0, p1) =>
                    salesController.setProductQuantity(p0, p1),
              ),
              buildProductCardText(
                context: context,
                index: index,
                label: "Subtotal",
                value: salesController.selectedProductList[index]['subtotal']
                    .toString(),
              ),
            ],
          ),
          // Text(salesController.selectedProductList[index]['quantity']
          //     .toString()),
          // Text(salesController.selectedProductList[index]['price'].toString()),
        ],
      ),
    );
  }

  Widget buildProductCardText({
    required BuildContext context,
    required String label,
    required int index,
    String? value,
    void Function(dynamic, String)? updateValue,
    // TextEditingController? controller
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: CustomPadding.extraSmallPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary)),
                Text(':',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary)),
              ],
            ),
          ),
          SizedBox(width: CustomPadding.smallPadding),
          (value != null)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(value,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary)),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    onChanged: (value) {
                      updateValue!(index, value);
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Masukkan $label",
                        contentPadding:
                            EdgeInsets.only(left: CustomPadding.smallPadding),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                  ),
                )
        ],
      ),
    );
  }
}
