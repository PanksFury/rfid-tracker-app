import 'package:get/get.dart';

import '../utility/api_service.dart';
import '../utility/constant_class.dart';

class SignupService extends GetConnect {
  Future<Map<String, dynamic>> register(FormData formData) async {
    Map<String, dynamic> result =
        await APIService().postData("${AppConstants.url}register", formData);

    return result;
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}users/$id",
      {},
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }

  Future<Map<String, dynamic>> updateUser(
      int id, Map<String, dynamic> formData) async {
    Map<String, dynamic> result = await APIService().putDataJson(
      "${AppConstants.url}users/$id",
      formData,
      headers: AppConstants.getAuthHeader(),
      contentType: 'application/json; charset=UTF-8',
    );

    return result;
  }
}
