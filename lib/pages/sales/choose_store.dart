import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/model/store_model.dart';
import 'package:flutter_alkabond_sales/pages/sales/control_button.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:get/get.dart';

class ChooseStore extends StatefulWidget {
  const ChooseStore({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<ChooseStore> createState() => _ChooseStoreState();
}

class _ChooseStoreState extends State<ChooseStore> {
  StoreModel? selectedStore;
  final _formAddStoreKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storePhoneNumberController =
      TextEditingController();
  final TextEditingController _storeCityBranchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.put(SalesController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Padding(
            padding:
                EdgeInsets.symmetric(horizontal: CustomPadding.largePadding),
            child: salesController.isLoading.isTrue
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
                          asyncItems: (text) => salesController.fetchStores(),
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
                                                      var result = await salesController.addStore(
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
          child: buildControlButton(context, widget.pageController),
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
}
