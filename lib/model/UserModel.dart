// ignore_for_file: file_names

class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? companyName;
  String? companyAddress;
  String? companyEmail;
  String? roleInCompany;
  int? roleId;
  int? userId;
  String? message;
  int? status;
  String? createdAt;
  String? updatedAt;

  UserModel({this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json["user"] == null) {
      return;
    }
    Map<String, dynamic> data = json["user"];
    id = data["id"];
    firstName = data["firstname"];
    lastName = data["lastname"];
    email = data["email"];
    mobile = data["mobile"];
    companyName = data["company_name"];
    companyAddress = data["company_address"];
    companyEmail = data["company_email_id"];
    roleInCompany = data["role_in_company"];
    roleId = data["role_id"];
    userId = data["user_id"];
    message = data["message"];
    status = data["status"];
    createdAt = data["created_at"];
    updatedAt = data["updated_at"];
  }

  UserModel.fromJsonList(Map<String, dynamic> data) {
    id = data["id"];
    firstName = data["firstname"];
    lastName = data["lastname"];
    email = data["email"];
    mobile = data["mobile"];
    companyName = data["company_name"];
    companyAddress = data["company_address"];
    companyEmail = data["company_email_id"];
    roleInCompany = data["role_in_company"];
    roleId = data["role_id"];
    userId = data["user_id"];
    message = data["message"];
    status = data["status"];
    createdAt = data["created_at"];
    updatedAt = data["updated_at"];
  }

  // ignore: annotate_overrides
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["id"] = id;
    data["firstname"] = firstName;
    data["lastname"] = lastName;
    data["email"] = email;
    data["mobile"] = mobile;
    data["company_name"] = companyName;
    data["company_address"] = companyAddress;
    data["company_email_id"] = companyEmail;
    data["role_in_company"] = roleInCompany;
    data["role_id"] = roleId;
    data["user_id"] = userId;
    data["message"] = message;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;

    return data;
  }
}
