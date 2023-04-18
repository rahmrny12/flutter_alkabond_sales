// To parse this JSON data, do
//
//     final type = typeFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

List<TypeModel> typeFromJson(String str) => List<TypeModel>.from(
    json.decode(str)['data'].map((x) => TypeModel.fromJson(x)));

String typeToJson(List<TypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeModel {
  TypeModel({
    required this.id,
    required this.type,
  });

  int id;
  String type;

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };

  isEqual(TypeModel s) {
    return id == s.id;
  }
}
