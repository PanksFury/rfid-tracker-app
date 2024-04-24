// ignore_for_file: file_names

import 'package:trainrsid/model/CommonModel.dart';

class RFIDModel extends CommonModel {
  int? id;
  String? userId;
  String? rsid;
  String? stationBackward;
  String? stationForward;
  String? currentLocation;
  String? notes;
  String? createdAt;
  String? updatedAt;

  RFIDModel() : super.fromJson(null);

  RFIDModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    Map<String, dynamic> data = json["data"];
    if (data["rsid"] == null) {
      return;
    }
    Map<String, dynamic> rsidData = data["rsid"];
    id = rsidData["id"];
    userId = rsidData["user_id"];
    rsid = rsidData["rsid"];
    stationBackward = rsidData["station_backward"];
    stationForward = rsidData["station_forward"];
    currentLocation = rsidData["current_location"];
    notes = rsidData["note"];
    updatedAt = rsidData["updated_at"];
    createdAt = rsidData["created_at"];
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["commonmodel"] = super.toJson();
    data["id"] = id;
    data["user_id"] = userId;
    data["rsid"] = rsid;
    data["station_backward"] = stationBackward;
    data["station_forward"] = stationForward;
    data["current_location"] = currentLocation;
    data["note"] = notes;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;

    return data;
  }
}
