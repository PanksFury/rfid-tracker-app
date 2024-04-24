// ignore_for_file: file_names

class CommonModel {
  String? message;
  bool? success;

  CommonModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      message = json["message"];
      success = json["success"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data["message"] = message;
    data["success"] = success;
    return data;
  }

  @override
  String toString() {
    return """
    {
      message:$message,
      success:$success,
    }
    """;
  }
}
