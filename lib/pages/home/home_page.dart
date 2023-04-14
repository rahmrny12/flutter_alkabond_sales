import 'package:flutter/material.dart';
import 'package:flutter_alkabond_sales/pages/dashboard/dashboard_page.dart';
import 'package:flutter_alkabond_sales/pages/home/home_controller.dart';
import 'package:flutter_alkabond_sales/pages/sales/sales_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          onTap: controller.changeTabIndex,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: controller.tabIndex,
          items: [
            _buildBottomNavItem(
              Icons.home,
              "Home",
            ),
            _buildBottomNavItem(
              Icons.payment,
              "Sales",
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: const [
              DashboardPage(),
              SalesPage(),
            ],
          ),
        ),
      );
    });
  }

  _buildBottomNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
      label: label,
    );
  }
}
