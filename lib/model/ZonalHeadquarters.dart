// ignore_for_file: file_names

import 'package:trainrsid/model/CommonModel.dart';

import 'StationZones.dart';

class ZonalHeadquarters extends CommonModel {
  List<ZonalHeadquarter> zonalHeadquarters = [];

  ZonalHeadquarters() : super.fromJson(null);

  ZonalHeadquarters.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    json["data"]["zonalHeadquarters"].forEach((e) {
      zonalHeadquarters.add(ZonalHeadquarter.fromJson(e));
    });
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["commonmodel"] = super.toJson();
    data["stationZones"] = zonalHeadquarters.map((e) => e.toJson());

    return data;
  }
}
