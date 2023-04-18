import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/model/product_model.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/model/type_model.dart';
import 'package:flutter_alkabond_sales/pages/home/home_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:get/get.dart';
import 'package:linear_step_indicator/linear_step_indicator.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  // final SalesController _salesController = Get.put(SalesController());

  int _currentStep = 0;
  StoreModel? selectedStore;
  final _formAddStoreKey = GlobalKey<FormState>();
  final _formAddProductKey = GlobalKey<FormState>();

  final PageController _pageController = PageController();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storePhoneNumberController =
      TextEditingController();
  final TextEditingController _storeCityBranchController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Transaksi'),
      ),
      body: StepIndicatorPageView(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          steps: 3,
          indicatorPosition: IndicatorPosition.top,
          labels: ['Toko', 'Checkout', 'Detail'],
          controller: _pageController,
          complete: () {
            //typically, you'd want to put logic that returns true when all the steps
            //are completed here
            return Future.value(true);
          },
          children: [
            buildChooseStore(),
            buildChooseProducts(),
            buildCheckout(),
          ]),
    );
  }

  Widget buildChooseStore() {
    final SalesController _salesController = Get.put(SalesController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Padding(
            padding:
                EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
            child: _salesController.isLoading.isTrue
                ? Padding(
                    padding: EdgeInsets.only(top: CustomPadding.mediumPadding),
                    child: const CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownSearch<StoreModel>(
                          popupProps: PopupProps.dialog(
                            dialogProps: DialogProps(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              contentTextStyle:
                                  Theme.of(context).textTheme.headline5,
                            ),
                            textStyle: Theme.of(context).textTheme.headline5,
                            showSelectedItems: true,
                            showSearchBox: true,
                          ),
                          compareFn: (item1, item2) => item1.isEqual(item2),
                          filterFn: (item, filter) =>
                              item.storeFilterByName(filter),
                          asyncItems: (text) => _salesController.fetchStores(),
                          itemAsString: (item) => item.storeName,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Pilih toko",
                            ),
                          ),
                          onChanged: (value) =>
                              setState(() => selectedStore = value),
                          selectedItem: selectedStore,
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  maxChildSize: 1,
                                  expand: false,
                                  initialChildSize: 0.8,
                                  minChildSize: 0.5,
                                  builder: (context, scrollController) {
                                    return Padding(
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
                                                          color: Colors.black)),
                                            ),
                                            buildAddStoreInput(
                                              context: context,
                                              label: "Nama Toko",
                                              hint: "Masukkan nama toko...",
                                              controller: _storeNameController,
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
                                            buildAddStoreInput(
                                              context: context,
                                              label: "Kota",
                                              hint: "Masukkan kota...",
                                              controller:
                                                  _storeCityBranchController,
                                            ),
                                            SizedBox(
                                                height: CustomPadding
                                                    .mediumPadding),
                                            Center(
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formAddStoreKey
                                                        .currentState!
                                                        .validate()) {
                                                      var result = await _salesController.addStore(
                                                          _storeNameController
                                                              .text,
                                                          _storeAddressController
                                                              .text,
                                                          _storePhoneNumberController
                                                              .text);
                                                      if (mounted)
                                                        Navigator.of(context)
                                                            .pop();
                                                    }
                                                  },
                                                  child: const Text("Tambah")),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: const Text("Tambah Toko")),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: CustomPadding.largePadding),
          child: buildControlButton(),
        ),
      ],
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
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
                  EdgeInsets.only(left: CustomPadding.mediumPadding),
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChooseProducts() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40))),
                    builder: (context) {
                      return DraggableScrollableSheet(
                        maxChildSize: 1,
                        expand: false,
                        initialChildSize: 0.9,
                        minChildSize: 0.9,
                        builder: (context, scrollController) {
                          return Form(
                            key: _formAddProductKey,
                            child: GetBuilder<SalesController>(
                                builder: (salesController) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: CustomPadding.mediumPadding,
                                        bottom: CustomPadding.smallPadding,
                                        left: CustomPadding.mediumPadding,
                                        right: CustomPadding.mediumPadding,
                                      ),
                                      child: Text('Jenis Produk',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(color: Colors.black)),
                                    ),
                                    FutureBuilder<List<TypeModel>>(
                                        future:
                                            salesController.fetchProductTypes(),
                                        builder: (context, snap) {
                                          if (snap.connectionState ==
                                              ConnectionState.done) {
                                            List<TypeModel> types = snap.data!;
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: CustomPadding
                                                      .mediumPadding),
                                              child: Wrap(
                                                spacing: CustomPadding
                                                    .extraSmallPadding,
                                                children: [
                                                  ...List.generate(
                                                    snap.data!.length,
                                                    (index) => GestureDetector(
                                                      onTap: () {
                                                        salesController
                                                            .selectProductByType(
                                                                types[index]);
                                                      },
                                                      child:
                                                          buildFilterProductType(
                                                              context,
                                                              types[index].type,
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
                                          top: CustomPadding.mediumPadding,
                                          bottom: CustomPadding.smallPadding,
                                          left: CustomPadding.mediumPadding,
                                          right: CustomPadding.mediumPadding),
                                      child: Text('Produk',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(color: Colors.black)),
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
                                                            .products[index]))),
                                    SizedBox(
                                        height: CustomPadding.mediumPadding),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              CustomPadding.mediumPadding),
                                      padding: EdgeInsets.symmetric(
                                          vertical: CustomPadding.smallPadding),
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
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: Size(150, 45),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary)),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            child: Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                fixedSize: Size(150, 45)),
                                            child: Text("Tambah"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      );
                    },
                  );
                },
                child: const Text("Tambah Produk"))),
        buildProductCard(),
        Padding(
          padding: EdgeInsets.only(bottom: CustomPadding.largePadding),
          child: buildControlButton(),
        ),
      ],
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

  Widget buildControlButton() {
    return Row(
      children: [
        SizedBox(width: CustomPadding.largePadding),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            child: Text("Kembali"),
          ),
        ),
        SizedBox(width: CustomPadding.largePadding),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            child: Text("Selanjutnya"),
          ),
        ),
        SizedBox(width: CustomPadding.largePadding),
      ],
    );
  }

  buildCheckout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text("Checkout")),
        Padding(
          padding: EdgeInsets.only(bottom: CustomPadding.largePadding),
          child: buildControlButton(),
        ),
      ],
    );
  }

  Widget buildProductCard() {
    return Container(
      padding: EdgeInsets.all(CustomPadding.extraSmallPadding),
      margin: EdgeInsets.all(CustomPadding.smallPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
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
              buildProductCardText(""),
              buildProductCardText(),
            ],
          )
        ],
      ),
    );
  }

  Row buildProductCardText(
      String label, String? value, TextEditingController controller) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Produk',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary)),
              Text(':',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary)),
            ],
          ),
        ),
        SizedBox(width: CustomPadding.extraSmallPadding),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text('Acian Putih - Alkabond 100 -MUI - 40 kg',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
        ),
      ],
    );
  }
}
