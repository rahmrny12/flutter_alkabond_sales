import 'dart:convert';
import 'dart:developer';

List<CityBranchModel> cityBranchesFromJson(String str) =>
    List<CityBranchModel>.from(json
        .decode(str)['data']['city_branches']
        .map((x) => CityBranchModel.fromJson(x)));

String cityBranchesToJson(List<CityBranchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityBranchModel {
  CityBranchModel({
    required this.id,
    required this.cityId,
    required this.branch,
  });

  int id;
  int cityId;
  String branch;

  factory CityBranchModel.fromJson(Map<String, dynamic> json) =>
      CityBranchModel(
        id: json["id"],
        cityId: int.parse(json["city_id"]),
        branch: json["branch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_id": cityId,
        "branch": branch,
      };
}
