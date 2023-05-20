import 'package:intl/intl.dart';

const String baseUrl = 'https://14ca-158-140-172-120.ngrok-free.app';
// const String baseUrl = 'http://penjualanbersama.000webhostapp.com';
// const String baseUrl = 'http://10.0.2.2:8000';
// pak rete
// const String baseUrl = 'http://192.168.0.110:8080';
// redmi 7a
// const String baseUrl = 'http://192.168.43.227:8000';

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
