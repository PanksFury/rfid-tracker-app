// ignore_for_file: file_names

import 'package:trainrsid/model/CommonModel.dart';

class StationCodes extends CommonModel {
  List<StationCode> stationCodes = [];

  StationCodes() : super.fromJson(null);

  StationCodes.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    json["data"]["station_codes"].forEach((e) {
      stationCodes.add(StationCode.fromJson(e));
    });
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["commonmodel"] = super.toJson();
    data["stationZones"] = stationCodes.map((e) => e.toJson());

    return data;
  }
}

class StationCode {
  int? id;
  String? name;
  String? code;
  int? status;
  String? createdAt;
  String? updatedAt;

  StationCode(
      {this.id,
      this.name,
      this.code,
      this.status,
      this.createdAt,
      this.updatedAt});

  StationCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
