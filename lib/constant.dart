import 'package:intl/intl.dart';

const String baseUrl = 'http://10.0.2.2:8000';
// String BASE_URL = 'http://10.0.2.2:8000';
const String imagePath = 'assets/img';

class CustomPadding {
  static double extraSmallPadding = 8;
  static double smallPadding = 14;
  static double mediumPadding = 24;
  static double largePadding = 36;
  static double extraLargePadding = 64;
}

String parseToRupiah(int price) {
  var rupiah = NumberFormat("#,##0", "id_ID");
  String formattedPrice = "Rp ${rupiah.format(price)}";
  return formattedPrice;
}
