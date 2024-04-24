// ignore_for_file: file_names

import 'package:trainrsid/model/CommonModel.dart';

class StationZones extends CommonModel {
  List<StationZone> stationZones = [];

  StationZones() : super.fromJson(null);

  StationZones.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    json["data"]["station_zones"].forEach((e) {
      stationZones.add(StationZone.fromJson(e));
    });
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["commonmodel"] = super.toJson();
    data["stationZones"] = stationZones.map((e) => e.toJson());

    return data;
  }
}

class StationZone {
  int? id;
  int? zonalHeadquarterId;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  ZonalHeadquarter? zonalHeadquarter;

  StationZone(
      {this.id,
      this.zonalHeadquarterId,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.zonalHeadquarter});

  StationZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zonalHeadquarterId = json['zonal_headquarter_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zonalHeadquarter = json['zonal_headquarter'] != null
        ? ZonalHeadquarter.fromJson(json['zonal_headquarter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['zonal_headquarter_id'] = zonalHeadquarterId;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (zonalHeadquarter != null) {
      data['zonal_headquarter'] = zonalHeadquarter!.toJson();
    }
    return data;
  }
}

class ZonalHeadquarter {
  int? id;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<StationZone>? stationZones = [];

  ZonalHeadquarter({this.id, this.name, this.createdAt, this.updatedAt});

  ZonalHeadquarter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json["status"];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json["station_zones"] != null) {
      json["station_zones"].forEach((e) {
        stationZones!.add(StationZone.fromJson(e));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
