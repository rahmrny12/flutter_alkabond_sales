// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

List<TransactionModel> transactionModelFromJson(dynamic str) =>
    List<TransactionModel>.from(str.map((x) => TransactionModel.fromJson(x)));

String transactionModelToJson(List<TransactionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.invoiceCode,
    required this.grandTotal,
    required this.storeId,
    required this.salesId,
    required this.paymentMethod,
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
    required this.payments,
    required this.transactionDetails,
  });

  int id;
  String invoiceCode;
  int grandTotal;
  int storeId;
  int salesId;
  String? paymentMethod;
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
  List<Payment> payments;
  List<TransactionDetail> transactionDetails;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
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
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromJson(x))),
        transactionDetails: List<TransactionDetail>.from(
            json["transaction_details"]
                .map((x) => TransactionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
        "transaction_details":
            List<dynamic>.from(transactionDetails.map((x) => x.toJson())),
      };
}

class Payment {
  Payment({
    required this.id,
    required this.totalPay,
    required this.transactionId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int totalPay;
  int transactionId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        totalPay: json["total_pay"],
        transactionId: json["transaction_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_pay": totalPay,
        "transaction_id": transactionId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class TransactionDetail {
  TransactionDetail({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.productCode,
    required this.productName,
    required this.productBrand,
    required this.unitWeight,
    required this.createdAt,
    required this.updatedAt,
    this.returns,
  });

  int id;
  int transactionId;
  int productId;
  int quantity;
  int price;
  int subtotal;
  String productCode;
  String productName;
  String productBrand;
  String unitWeight;
  DateTime createdAt;
  DateTime updatedAt;
  Returns? returns;

  factory TransactionDetail.fromJson(Map<String, dynamic> json) =>
      TransactionDetail(
        id: json["id"],
        transactionId: json["transaction_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        price: json["price"],
        subtotal: json["subtotal"],
        productCode: json["product_code"],
        productName: json["product_name"],
        productBrand: json["product_brand"],
        unitWeight: json["unit_weight"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        returns:
            json["returns"] == null ? null : Returns.fromJson(json["returns"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "subtotal": subtotal,
        "product_code": productCode,
        "product_name": productName,
        "product_brand": productBrand,
        "unit_weight": unitWeight,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "returns": returns?.toJson(),
      };
}

class Returns {
  Returns({
    required this.id,
    required this.returnsReturn,
    required this.descriptionReturn,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int returnsReturn;
  String descriptionReturn;
  DateTime createdAt;
  DateTime updatedAt;

  factory Returns.fromJson(Map<String, dynamic> json) => Returns(
        id: json["id"],
        returnsReturn: json["return"],
        descriptionReturn: json["description_return"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "return": returnsReturn,
        "description_return": descriptionReturn,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
