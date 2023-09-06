// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

List<StoreModel> storeFromJson(String str) {
  return List<StoreModel>.from(
      json.decode(str)['data']['stores'].map((x) => StoreModel.fromJson(x)));
}

String storeToJson(List<StoreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreModel {
  StoreModel({
    required this.id,
    required this.storeName,
    required this.address,
    required this.storeNumber,
    required this.cityBranch,
    required this.salesId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String storeName;
  String address;
  String storeNumber;
  String cityBranch;
  int salesId;
  DateTime createdAt;
  DateTime updatedAt;

  bool storeFilterByName(String filter) {
    return storeName.toString().contains(filter);
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json["id"],
      storeName: json["store_name"],
      address: json["address"],
      storeNumber: json["store_number"],
      cityBranch: json["city_branch"],
      salesId: json["sales_id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "address": address,
        "store_number": storeNumber,
        "city_branch": cityBranch,
        "sales_id": salesId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  isEqual(StoreModel s) {
    return id == s.id;
  }
}
