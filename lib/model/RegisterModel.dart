// ignore_for_file: file_names

import 'CommonModel.dart';
import 'UserModel.dart';

class RegisterModel extends CommonModel {
  String? token;
  String? error;
  UserModel? userModel;

  RegisterModel({this.userModel}) : super.fromJson(null);

  RegisterModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json["data"] == null) {
      return;
    }
    Map<String, dynamic> data = json["data"];
    token = data["token"];
    error = data["error"];
    userModel = UserModel.fromJson(data);
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["token"] = token;
    data["error"] = error;

    data["commonmodel"] = super.toJson();
    data["user"] = userModel!.toJson();

    return data;
  }
}
