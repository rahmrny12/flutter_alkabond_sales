import 'package:get/get.dart';

class HomeController extends GetxController {
  var tabIndex = 0;

  changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
