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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: ElevatedButton(
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.remove("login_token");
            if (!mounted) return;
            Navigator.pop(context);
            Get.toNamed("/login");
          },
          child: Text("Logout"),
        ));
  }
}
