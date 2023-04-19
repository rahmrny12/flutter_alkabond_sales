// To parse this JSON data, do
//
//     final transactionDetailModel = transactionDetailModelFromJson(jsonString);

import 'dart:convert';

TransactionDetailModel transactionDetailModelFromJson(String str) =>
    TransactionDetailModel.fromJson(json.decode(str));

String transactionDetailModelToJson(TransactionDetailModel data) =>
    json.encode(data.toJson());

class TransactionDetailModel {
  TransactionDetailModel({
    required this.data,
    required this.subdata,
  });

  Data data;
  List<ProductDetail> subdata;

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailModel(
        data: Data.fromJson(json["data"]),
        subdata: List<ProductDetail>.from(
            json["subdata"].map((x) => ProductDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "subdata": List<dynamic>.from(subdata.map((x) => x.toJson())),
      };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

class ProductDetail {
  ProductDetail({
    required this.id,
    required this.invoiceCode,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.productCode,
    required this.productName,
    required this.productBrand,
    required this.unitWeight,
    this.subdatumReturn,
    this.descriptionReturn,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String invoiceCode;
  int productId;
  int quantity;
  int price;
  int subtotal;
  String productCode;
  String productName;
  String productBrand;
  String unitWeight;
  dynamic subdatumReturn;
  dynamic descriptionReturn;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"],
        invoiceCode: json["invoice_code"],
        productId: json["product_id"],
        quantity: json["quantity"],
        price: json["price"],
        subtotal: json["subtotal"],
        productCode: json["product_code"],
        productName: json["product_name"],
        productBrand: json["product_brand"],
        unitWeight: json["unit_weight"],
        subdatumReturn: json["return"],
        descriptionReturn: json["description_return"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_code": invoiceCode,
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "subtotal": subtotal,
        "product_code": productCode,
        "product_name": productName,
        "product_brand": productBrand,
        "unit_weight": unitWeight,
        "return": subdatumReturn,
        "description_return": descriptionReturn,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
