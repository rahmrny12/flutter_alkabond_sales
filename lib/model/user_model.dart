// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.data,
    required this.accessToken,
    required this.tokenType,
    required this.statusCode,
  });

  Data data;
  String accessToken;
  String tokenType;
  int statusCode;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        data: Data.fromJson(json["data"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        statusCode: json["status_code"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
        "status_code": statusCode,
      };
}

class Data {
  Data({
    required this.id,
    required this.salesName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String salesName;
  String username;
  String email;
  String phoneNumber;
  String city;
  DateTime createdAt;
  DateTime updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        salesName: json["sales_name"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        city: json["city"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sales_name": salesName,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "city": city,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
