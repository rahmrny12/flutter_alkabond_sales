// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

List<TransactionModel> transactionModelFromJson(var str) =>
    List<TransactionModel>.from(str.map((x) => TransactionModel.fromJson(x)));

String transactionModelToJson(List<TransactionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionModel {
  TransactionModel({
    required this.invoiceCode,
    required this.grandTotal,
    required this.storeId,
    required this.salesId,
    this.paymentMethod,
    required this.status,
    required this.deliveryStatus,
    required this.storeName,
    required this.address,
    required this.storeNumber,
    required this.cityBranch,
    required this.salesName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  String invoiceCode;
  int grandTotal;
  int storeId;
  int salesId;
  dynamic paymentMethod;
  String status;
  String deliveryStatus;
  String storeName;
  String address;
  String storeNumber;
  String cityBranch;
  String salesName;
  String username;
  String email;
  String phoneNumber;
  String city;
  DateTime createdAt;
  DateTime updatedAt;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        invoiceCode: json["invoice_code"],
        grandTotal: json["grand_total"],
        storeId: json["store_id"],
        salesId: json["sales_id"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        deliveryStatus: json["delivery_status"],
        storeName: json["store_name"],
        address: json["address"],
        storeNumber: json["store_number"],
        cityBranch: json["city_branch"],
        salesName: json["sales_name"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        city: json["city"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "invoice_code": invoiceCode,
        "grand_total": grandTotal,
        "store_id": storeId,
        "sales_id": salesId,
        "payment_method": paymentMethod,
        "status": status,
        "delivery_status": deliveryStatus,
        "store_name": storeName,
        "address": address,
        "store_number": storeNumber,
        "city_branch": cityBranch,
        "sales_name": salesName,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "city": city,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
