import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/RegisterModel.dart';

class AppConstants {
  static bool isDebug = true;

  static int passwordLength = 8;

  //region APIS Key
  // ignore: non_constant_identifier_names
  static String GOOGLE_API_KEY =
      "AIzaSyBI8HWS_TriF1-wNyt2uWYLT4on9uSzV00"; //LIVE "AIzaSyABPlrGT9BqvUIRbXHoTF32q5cJQ94dAkA"; //Geocoding and maps key
  //endregion
  //APIs
  // static String url = "https://rfidapi.lotusoft.in/api/";
  static String url = "https://rfidapis.mirificalinfra.in/api/";
  //"http://apis.mirificalinfra.in/api/";
  // "http://trainrfid.wehost.tech/api/";
  static Duration timeoutDuration = const Duration(minutes: 2);
  //endregion

  //region BoxStorage
  static String userToken = "userToken";
  static String userId = "userId";
  static String userName = "userName";
  static String firstName = "firstName";
  static String lastName = "lastName";
  static String mobile = "mobile";
  static String roleId = "roleId";
  static String emailId = "emailId";
  static String status = "status";
  //endregion

  ///Set the userId and userToken as auth Header in Shared preference
  static Future<void> setAuthHeader(RegisterModel registerModel) async {
    var box = GetStorage();
    await box.write(userId, registerModel.userModel!.id.toString());
    if (registerModel.token != null) {
      await box.write(userToken, registerModel.token!);
    }
    await box.write(firstName, registerModel.userModel!.firstName);
    await box.write(lastName, registerModel.userModel!.lastName);
    await box.write(mobile, registerModel.userModel!.mobile);
    await box.write(roleId, registerModel.userModel!.roleId);
    await box.write(emailId, registerModel.userModel!.email);
    await box.write(status, registerModel.userModel!.status);
  }

  ///Get the auth header map with Userid and Apikey
  static Map<String, String> getAuthHeader({String? contentType}) {
    var box = GetStorage();
    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    var _userId = box.read(userId) ?? "";
    // ignore: no_leading_underscores_for_local_identifiers
    var _userToken = box.read(userToken) ?? "";

    Map<String, String> data = {
      "Authorization": 'Bearer $_userToken',
    };

    if (contentType != null) {
      data["Content-Type"] = contentType; // "application/x-www-form-urlencoded"
    }

    debugPrint("AuthHeader: $data");

    return data;
  }

  ///Get the auth header map with Userid and Apikey
  static String getUserId() {
    var box = GetStorage();
    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    var _userId = box.read(userId) ?? "";

    return _userId;
  }

  //region Snackbars
  ///Display Snackbar for Validations
  static void displayValidationErrorSnackbar(String message) {
    Get.closeAllSnackbars();
    Get.snackbar("Validation Error", message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  ///Display Snackbar for Validations
  static void displaySuccessfulSnackbar(String message, {Duration? duration}) {
    duration ??= const Duration(seconds: 3);
    Get.snackbar(
      "Successful",
      message,
      backgroundColor: Colors.white,
      colorText: Get.theme.primaryColor,
      duration: duration,
    );
  }

  ///Display Snackbar for Error
  static void displayErrorSnackbar(String message, {String title = "Error"}) {
    Get.closeAllSnackbars();
    Get.snackbar(title, message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  static void displaySomethingWentWrongSnackbar() {
    Get.snackbar(
      "Error",
      "Something went wrong",
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }
  //endregion
}

//region enums
// ignore: constant_identifier_names
enum STATUS { REJECTED, APPROVED, PENDING, SUSPENDED, ALL }

// ignore: constant_identifier_names
enum ROLE { UNKNOWN, ADMIN, USER }
  //endregion