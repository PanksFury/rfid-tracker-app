// ignore_for_file: file_names

import 'CommonModel.dart';
import 'UserModel.dart';

class UserListModel extends CommonModel {
  String? token;
  String? error;
  int? totalNoOfUsers;
  List<UserModel> userList = [];

  UserModel userData = UserModel();

  UserListModel() : super.fromJson(null);

  UserListModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    Map<String, dynamic> data = json["data"];
    token = data["token"];
    error = data["error"];
    totalNoOfUsers = data["total_users"];
    if (data["users"] != null) {
      data["users"].forEach((e) {
        userList.add(UserModel.fromJsonList(e));
      });
    }
  }

  UserListModel.fromSingleJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    Map<String, dynamic> data = json["data"];
    token = data["token"];
    error = data["error"];
    totalNoOfUsers = data["total_users"];
    userData = UserModel.fromJson(data);
    if (data["users"] != null) {
      data["users"].forEach((e) {
        userList.add(UserModel.fromJsonList(e));
      });
    }
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["token"] = token;
    data["error"] = error;
    data["total_users"] = totalNoOfUsers;

    data["commonmodel"] = super.toJson();
    data["users"] = userList.map((v) => v.toJson()).toList();

    return data;
  }
}
