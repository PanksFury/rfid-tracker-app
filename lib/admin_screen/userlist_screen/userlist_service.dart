import 'package:get/get.dart';

import '../../utility/api_service.dart';
import '../../utility/constant_class.dart';

class UserListService extends GetConnect {
  Future<Map<String, dynamic>> getUserList(Map<String, dynamic> query) async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}users",
      query,
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }

  Future<Map<String, dynamic>> makeStatusRequest(FormData formData) async {
    Map<String, dynamic> result = await APIService().postData(
      "${AppConstants.url}approve-user",
      formData,
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }
}
