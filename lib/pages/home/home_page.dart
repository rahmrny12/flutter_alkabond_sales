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
  final controller = Get.put(HomeController());
  late ScrollController _scrollController;
  static const kExpandedHeight = 200.0;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients &&
            _scrollController.offset > kExpandedHeight - kToolbarHeight) {
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
    return GetBuilder<HomeController>(builder: (controller) {
      return IndexedStack(
        index: controller.tabIndex,
        children: [
          Scaffold(
            bottomNavigationBar: buildNavBar(context, controller),
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Sejahtera",
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  Text(
                                    "Bersama",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/img/logo.png",
                                width: 130,
                              ),
                            ],
                          ),
                        ),
                      ),
                      centerTitle: true,
                      title: isExpanded
                          ? Text("Sejahtera Bersama",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ))
                          : null,
                    ),
                  ),
                ];
              },
              body: const DashboardPage(),
            ),
          ),
          const SalesPage(),
        ],
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
          Icons.home,
          "Home",
        ),
        _buildBottomNavItem(
          Icons.account_circle,
          "Sales",
        ),
      ],
    );
  }

  _buildBottomNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
      label: label,
    );
  }
}
