import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/PlaceModel.dart';

class MapController extends GetxController {
  var selectedLocation = const PlaceLocation(latitude: 0.0, longitude: 0.0).obs;
  Rx<LatLng?> pickedLocation = const LatLng(0, 0).obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    selectedLocation.value = Get.arguments;
    pickedLocation.value = LatLng(
        selectedLocation.value.latitude!, selectedLocation.value.longitude!);
    isLoading.value = false;
  }
}
