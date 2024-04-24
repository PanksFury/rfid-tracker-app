import 'package:get/get.dart';

import '../../utility/api_service.dart';
import '../../utility/constant_class.dart';

class AddRFIDService extends GetConnect {
  Future<Map<String, dynamic>> addRsid(FormData formData) async {
    Map<String, dynamic> result = await APIService().postData(
      "${AppConstants.url}rsids",
      formData,
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }

  Future<Map<String, dynamic>> getRFIDById(int id) async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}rsids/$id",
      {},
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }

  Future<Map<String, dynamic>> getZonalHeadQuarters() async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}zonal-headquarters",
      {},
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }

  Future<Map<String, dynamic>> getStationZones() async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}station-zones",
      {},
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }

  Future<Map<String, dynamic>> getStationCode() async {
    Map<String, dynamic> result = await APIService().getData(
      "${AppConstants.url}station-codes",
      {},
      headers: AppConstants.getAuthHeader(),
    );

    return result;
  }
}
