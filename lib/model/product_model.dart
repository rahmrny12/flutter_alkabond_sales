// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str)['data'].map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    required this.id,
    required this.productCode,
    required this.productName,
    required this.productBrand,
    this.unitWeight,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String productCode;
  String productName;
  String productBrand;
  dynamic unitWeight;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productCode: json["product_code"],
        productName: json["product_name"],
        productBrand: json["product_brand"],
        unitWeight: json["unit_weight"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_code": productCode,
        "product_name": productName,
        "product_brand": productBrand,
        "unit_weight": unitWeight,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
