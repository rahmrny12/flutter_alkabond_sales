import 'package:flutter/material.dart';
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
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Akun Sales'),
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
                child: Column(
              children: [
                Image.network(
                  "src",
                  width: 140,
                ),
                Text(_prefs?.getString("username") ?? "Username"),
              ],
            )),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  _prefs?.remove("login_token");
                  if (!mounted) return;
                  Navigator.pop(context);
                  Get.toNamed("/login");
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
