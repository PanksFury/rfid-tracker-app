import 'dart:io';

import 'package:get/get.dart';

import '../utility/api_service.dart';
import '../utility/constant_class.dart';

class LoginService extends GetConnect {
  Future<Map<String, dynamic>> login(FormData formData) async {
    Map<String, dynamic> result = await APIService().postData(
        "${AppConstants.url}login", formData,
        statusCodeCondition: HttpStatus.notFound);

    return result;
  }

  Future<Map<String, dynamic>> forgetPassword(FormData formData) async {
    Map<String, dynamic> result = await APIService().postData(
        "${AppConstants.url}forgetPassword", formData,
        statusCodeCondition: HttpStatus.notFound);

    return result;
  }
}
