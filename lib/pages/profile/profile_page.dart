import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/constant.dart';
import 'package:flutter_alkabond_sales/helper/message_dialog.dart';
import 'package:flutter_alkabond_sales/pages/home/home_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients &&
            _scrollController.offset > kExpandedHeight / 2) {
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
    return Scaffold(
        body: NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text('Akun Sales'),
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(isExpanded ? 0 : 25),
            )),
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "$imagePath/user-default.png",
                    width: MediaQuery.of(context).size.height * 0.3 * 0.4,
                  ),
                  SizedBox(
                    height: CustomPadding.smallPadding,
                  ),
                  Text(
                    _prefs?.getString("username") ?? "Username",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: CustomPadding.largePadding,
                  ),
                ],
              )),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: CustomPadding.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: CustomPadding.largePadding,
              ),
              Text(
                "Nama",
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.smallPadding,
                    vertical: CustomPadding.extraSmallPadding),
                child: Text(
                  _prefs?.getString("name") ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: CustomPadding.smallPadding),
              Text(
                "Email",
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.smallPadding,
                    vertical: CustomPadding.extraSmallPadding),
                child: Text(
                  _prefs?.getString("email") ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: CustomPadding.smallPadding),
              Text(
                "Nomor HP",
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.smallPadding,
                    vertical: CustomPadding.extraSmallPadding),
                child: Text(
                  _prefs?.getString("phone_number") ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: CustomPadding.smallPadding),
              Text(
                "Kota",
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.smallPadding,
                    vertical: CustomPadding.extraSmallPadding),
                child: Text(
                  _prefs?.getString("city") ?? "-",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: CustomPadding.largePadding,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    showConfirmationDialog(
                      context: context,
                      text:
                          "Yakin ingin keluar? Anda akan login ulang kembali..",
                      onPressed: () {
                        _prefs?.remove("login_token");
                        if (!mounted) return;
                        Navigator.pop(context);
                        Get.toNamed("/login");
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
