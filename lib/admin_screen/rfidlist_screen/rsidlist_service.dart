import 'package:get/get.dart';

import '../../utility/api_service.dart';
import '../../utility/constant_class.dart';

class RFIDListService extends GetConnect {
  Future<Map<String, dynamic>> getRsidList(Map<String, dynamic> query) async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}rsids",
      query,
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }
}
