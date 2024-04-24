import 'package:get/get.dart';

import '../utility/api_service.dart';
import '../utility/constant_class.dart';

class SplashService extends GetConnect {
  Future<Map<String, dynamic>> getUserByToken() async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}get-user-by-token",
      {},
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }
}
