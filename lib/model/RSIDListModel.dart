// ignore_for_file: file_names

import 'package:trainrsid/model/CommonModel.dart';

import 'UserModel.dart';

class RFIDListModel extends CommonModel {
  List<RSIDDataModel> rsidList = [];

  RSIDDataModel rfidData = RSIDDataModel();

  RFIDListModel() : super.fromJson(null);

  RFIDListModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    Map<String, dynamic> data = json["data"];
    if (data["rsids"] != null) {
      data["rsids"].forEach((e) {
        rsidList.add(RSIDDataModel.fromJson(e));
      });
    }
  }

  RFIDListModel.fromSingleJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    Map<String, dynamic> data = json["data"];
    rfidData = RSIDDataModel.fromJson(data["rsid"]);
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["commonmodel"] = super.toJson();
    data["rsids"] = rsidList.map((e) => e.toJson()).toList();
    data["rsid"] = rfidData.toJson();

    return data;
  }
}

class RSIDDataModel {
  int? id;
  int? userId;
  String? rsid;
  String? stationBackward;
  String? stationForward;
  String? currentLocation;
  String? notes;
  String? createdAt;
  String? updatedAt;
  int? totalRides;
  double? latitude;
  double? longitude;
  UserModel? userModel;

  RSIDDataModel();

  RSIDDataModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    rsid = json["rsid"];
    stationBackward = json["station_backward"];
    stationForward = json["station_forward"];
    currentLocation = json["current_location"];
    notes = json["note"];
    updatedAt = json["updated_at"];
    createdAt = json["created_at"];
    totalRides = json["total_rsids"];
    latitude = double.tryParse(json["latitude"]) ?? 0.0;
    longitude = double.tryParse(json["longitude"]) ?? 0.0;
    userModel = UserModel.fromJson(json);
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["id"] = id;
    data["user_id"] = userId;
    data["rsid"] = rsid;
    data["station_backward"] = stationBackward;
    data["station_forward"] = stationForward;
    data["current_location"] = currentLocation;
    data["note"] = notes;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["total_rsids"] = totalRides;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["user"] = userModel == null ? null : userModel!.toJson();

    return data;
  }
}
