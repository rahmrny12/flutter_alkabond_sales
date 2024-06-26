import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_page.dart';
import 'package:get/get.dart';

class ChooseStore extends StatefulWidget {
  const ChooseStore({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<ChooseStore> createState() => _ChooseStoreState();
}

class _ChooseStoreState extends State<ChooseStore> {
  final _formAddStoreKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storePhoneNumberController =
      TextEditingController();
  int? _storeCityBranchController;
  final SalesController salesController = Get.put(SalesController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
              child: salesController.isLoading.isTrue
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: CustomPadding.mediumPadding,
                          bottom: CustomPadding.extraLargePadding),
                      child: const CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownSearch<StoreModel>(
                            popupProps: PopupProps.dialog(
                                // constraints: BoxConstraints(
                                //   maxHeight:
                                //       MediaQuery.of(context).size.height * 0.5,
                                // ),
                                dialogProps: DialogProps(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface),
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
                            asyncItems: (text) => salesController.fetchStores(),
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
                                  labelText: "Pilih toko",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: Colors.white)),
                            ),
                            dropdownBuilder:
                                (BuildContext context, StoreModel? store) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: CustomPadding.extraSmallPadding),
                                child: Text(
                                    store == null
                                        ? "-"
                                        : "${store.storeName} - ${store.address}",
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              );
                            },
                            onChanged: (value) =>
                                salesController.selectedStore.value = value,
                            selectedItem: salesController.selectedStore.value,
                          ),
                        ),
                        SizedBox(height: CustomPadding.smallPadding),
                        Text(
                          "Jika toko tidak ada dalam pilihan, silahkan tambah toko",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: CustomPadding.mediumPadding),
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: SingleChildScrollView(
                                      // controller: scrollController,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                CustomPadding.largePadding),
                                        child: Form(
                                          key: _formAddStoreKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: CustomPadding
                                                        .mediumPadding,
                                                    bottom: CustomPadding
                                                        .smallPadding),
                                                child: Text('Tambah Toko',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                            color:
                                                                Colors.black)),
                                              ),
                                              buildAddStoreInput(
                                                context: context,
                                                label: "Nama Toko",
                                                hint: "Masukkan nama toko...",
                                                controller:
                                                    _storeNameController,
                                              ),
                                              buildAddStoreInput(
                                                context: context,
                                                label: "Alamat",
                                                hint: "Masukkan alamat...",
                                                controller:
                                                    _storeAddressController,
                                              ),
                                              buildAddStoreInput(
                                                context: context,
                                                label: "Nomer HP",
                                                hint: "Masukkan nomer hp...",
                                                controller:
                                                    _storePhoneNumberController,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: CustomPadding
                                                        .extraSmallPadding),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Cabang Kota",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSecondary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                    SizedBox(
                                                        height: CustomPadding
                                                                .smallPadding /
                                                            2),
                                                    DropdownButtonFormField(
                                                      items: salesController
                                                          .cityBranches
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                  value: e.id,
                                                                  child: Text(e
                                                                      .branch)))
                                                          .toList(),
                                                      onChanged: (value) =>
                                                          setState(() =>
                                                              _storeCityBranchController =
                                                                  value),
                                                      value:
                                                          _storeCityBranchController,
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Cabang Kota wajib diisi.';
                                                        }
                                                        return null;
                                                      },
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSecondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                      decoration:
                                                          addStoreInputDecoration(
                                                              context,
                                                              "Masukkan cabang toko..."),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: CustomPadding
                                                      .mediumPadding),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_formAddStoreKey
                                                          .currentState!
                                                          .validate()) {
                                                        Navigator.pop(context);
                                                        await salesController.addStore(
                                                            context,
                                                            mounted,
                                                            _storeNameController
                                                                .text,
                                                            _storeAddressController
                                                                .text,
                                                            _storePhoneNumberController
                                                                .text,
                                                            _storeCityBranchController!);
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                    ),
                                                    child: Text(
                                                      "Tambah",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              width: 2,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                    ),
                                                    child: Text(
                                                      "Batal",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6!
                                                          .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                    )),
                                              ),
                                              SizedBox(
                                                  height: CustomPadding
                                                      .extraLargePadding)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                  width: CustomPadding.smallPadding,
                                ),
                                Text(
                                  "Tambah Toko",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                ),
                              ],
                            )),
                        // SizedBox(height: CustomPadding.mediumPadding),
                        // Text(
                        //   (salesController.errorMessage.value.isNotEmpty)
                        //       ? salesController.errorMessage.value
                        //       : (salesController
                        //               .successMessage.value.isNotEmpty)
                        //           ? salesController.successMessage.value
                        //           : "",
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .headline6!
                        //       .copyWith(
                        //           fontWeight: FontWeight.w400,
                        //           color: (salesController
                        //                   .errorMessage.value.isEmpty)
                        //               ? Theme.of(context).colorScheme.secondary
                        //               : Theme.of(context).colorScheme.error),
                        // ),
                        SizedBox(height: CustomPadding.extraLargePadding),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: CustomPadding.largePadding),
            child: Row(
              children: [
                SizedBox(width: CustomPadding.largePadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // widget.pageController.previousPage(
                      //     duration: Duration(milliseconds: 200),
                      //     curve: Curves.easeIn);
                      showConfirmationDialog(
                          context: context,
                          text: "Yakin ingin membatalkan transaksi?",
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });

                      salesController.currentStep.value =
                          widget.pageController.page!.round();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary))),
                    child: Text("Kembali"),
                  ),
                ),
                SizedBox(width: CustomPadding.largePadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (salesController.selectedStore.value != null) {
                        widget.pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                        salesController.currentStep.value =
                            widget.pageController.page!.round();
                      } else {
                        buildAlertSnackBar(
                            context, "Pilih toko terlebih dahulu...");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text("Selanjutnya"),
                  ),
                ),
                SizedBox(width: CustomPadding.largePadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddStoreInput({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: CustomPadding.extraSmallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: CustomPadding.smallPadding / 2),
          TextFormField(
            keyboardType: (label.toLowerCase() == "nomer hp")
                ? TextInputType.number
                : TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib diisi.';
              }
              return null;
            },
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w400),
            decoration: addStoreInputDecoration(context, hint),
          ),
        ],
      ),
    );
  }

  InputDecoration addStoreInputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.only(left: CustomPadding.mediumPadding),
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
          fontWeight: FontWeight.w400),
    );
  }
}
