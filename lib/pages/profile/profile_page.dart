import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/pages/home/home_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_controller.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(child: Text("Profile")));
  }
}
