import 'dart:convert';

import 'package:intl/intl.dart';

// const String baseUrl = 'http://192.168.1.22:8000';
// const String baseUrl = 'http://penjualanbersama.000webhostapp.com';
// const String baseUrl = 'http://10.0.2.2:8000';.
// pak rete
// const String baseUrl = 'http://192.168.0.119:8000';
// redmi 7a
// const String baseUrl = 'http://192.168.43.227:8000';
// hosting dapur
const String baseUrl = 'https://mortaralkabon.com';
// ababil
// const String baseUrl = 'http://192.168.1.19:8000';

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

int rupiahStringToInt(String rupiahString) {
  // Remove any non-digit characters and parse as an integer
  final cleanedString = rupiahString.replaceAll(RegExp(r'[^\d]'), '');
  return int.tryParse(cleanedString) ?? 0; // Default to 0 if parsing fails
}
