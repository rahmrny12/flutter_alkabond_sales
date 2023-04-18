import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_page.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:flutter_alkabond_sales/pages/profile/profile_page.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_page.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<HomeController>(() => HomeController());

    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        bottomNavigationBar: buildNavBar(context, controller),
        body: IndexedStack(
          index: controller.tabIndex,
          children: [
            DashboardPage(),
            ProfilePage(),
          ],
        ),
      );
    });
  }

  BottomNavigationBar buildNavBar(
      BuildContext context, HomeController controller) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: controller.changeTabIndex,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      currentIndex: controller.tabIndex,
      items: [
        _buildBottomNavItem(
          context,
          Icons.home,
          "Home",
        ),
        _buildBottomNavItem(
          context,
          Icons.account_circle,
          "Profile",
        ),
      ],
    );
  }

  _buildBottomNavItem(context, IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
      label: label,
    );
  }
}
