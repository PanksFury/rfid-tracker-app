import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:trainrsid/model/UserModel.dart';

import '../../helpers/location_helper.dart';
import '../../model/PlaceModel.dart';
import '../../model/RSIDListModel.dart';
import '../../model/RSIDModel.dart';
import '../../model/StationCodes.dart';
import '../../model/StationZones.dart';
import '../../model/UserListModel.dart';
import '../../model/ZonalHeadquarters.dart';
import '../../signup_screen/signup_service.dart';
import '../../utility/constant_class.dart';
import 'add_rsid_service.dart';

enum StationType { zone, code, from }
enum Direction { left, right }

class AddRFIDController extends GetxController {
  var isLoading = true.obs;

  var rsidController = TextEditingController().obs;
  var stationZoneController = TextEditingController().obs;
  var stationCodeController = TextEditingController().obs;

  /* +++++++ */
  var stationFromController = TextEditingController().obs;
  var selectedDirection = Direction.left.obs;
  var numericInputValue = ''.obs;

  var currentLocationController = TextEditingController().obs;
  var noteController = TextEditingController().obs;
  RoundedLoadingButtonController addButtonController =
      RoundedLoadingButtonController();

  RoundedLoadingButtonController currentLocationButton =
      RoundedLoadingButtonController();

  RoundedLoadingButtonController pickLocationButton =
      RoundedLoadingButtonController();

  var box = GetStorage();

  var isLocationLoaded = false.obs;
  var selectedPlace = PlaceLocation().obs;
  var staticMapImageUrl = "".obs;

  var isReadonly = true.obs;
  var editRsidModel = RSIDDataModel().obs;
  var stationListStore = List<StationZone>.of([]).obs;
  var stationList = List<StationZone>.of([]).obs;
  var isStationListLoading = true.obs;

  var zonalListStore = List<ZonalHeadquarter>.of([]).obs;
  var zonalList = List<ZonalHeadquarter>.of([]).obs;
  var isStationTypeLoading = true.obs;
  var selectedStationZone = StationZone();

  var stationCodeListStore = List<StationCode>.of([]).obs;
  var stationCodeList = List<StationCode>.of([]).obs;
  var selectedStationCode = StationCode();

  var stationFromListStore = List<StationCode>.of([]).obs;
  var stationFromList = List<StationCode>.of([]).obs;
  var selectedStationFrom = StationCode();

  var userModel = UserModel().obs;

  late var data;

  @override
  Future<void> onInit() async {
    super.onInit();
    data = Get.arguments;
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    isLocationLoaded.value = false;
    isReadonly.value = data["isReadOnly"] ?? false;
    if (isReadonly.value) {
      editRFIDPopulate(data["data"]);
      await getRFIDById();
    } else {
      await getCurrentLocation();
    }

    isLocationLoaded.value = true;
    isLoading.value = false;
  }

  void editRFIDPopulate(RSIDDataModel rsidModel) {
    editRsidModel.value = rsidModel;
    rsidController.value.text = editRsidModel.value.rsid ?? "";
    stationZoneController.value.text = editRsidModel.value.stationForward ?? "";
    stationCodeController.value.text = editRsidModel.value.stationBackward ?? "";
    stationFromController.value.text = editRsidModel.value.stationForward ?? "";

    currentLocationController.value.text =
        editRsidModel.value.currentLocation ?? "";
    noteController.value.text = editRsidModel.value.notes ?? "";
    updateLocationPreview(
      editRsidModel.value.latitude!,
      editRsidModel.value.longitude!,
      isUpdateCurrentLocationController: false,
    );
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      Get.dialog(
        AlertDialog(
          title: const Text("Alert"),
          content: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              "This app collects location data to enable 'To Add Precise Location of RFID' even when the app is closed or not in use.",
              textAlign: TextAlign.justify,
              style: Get.textTheme.bodySmall,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.close(2);
                return;
              },
              child: const Text("Deny"),
            ),
            MaterialButton(
              onPressed: () async {
                Get.back();
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }

                try {
                  var locData = await location.getLocation();
                  selectedPlace.value = PlaceLocation(
                      latitude: locData.latitude!,
                      longitude: locData.longitude!,
                      address: "");
                  // staticMapImageUrl.value = LocationHelper.generateLocationPreviewImage(
                  //   latitude: locData.latitude!,
                  //   longitude: locData.longitude!,
                  // );
                  updateLocationPreview(locData.latitude!, locData.longitude!);
                  print("StaticMapURL: ${locData}");
                } catch (e) {
                  print("error: $e");
                }
              },
              child: const Text("Accept"),
            ),
          ],
        ),
      );
    } else {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }

      try {
        var locData = await location.getLocation();
        selectedPlace.value = PlaceLocation(
            latitude: locData.latitude!,
            longitude: locData.longitude!,
            address: "");
        // staticMapImageUrl.value = LocationHelper.generateLocationPreviewImage(
        //   latitude: locData.latitude!,
        //   longitude: locData.longitude!,
        // );
        updateLocationPreview(locData.latitude!, locData.longitude!);
        print("StaticMapURL: ${locData}");
      } catch (e) {
        print("error: $e");
      }
    }
  }

  void updateLocationPreview(double latt, double long,
      {bool isUpdateCurrentLocationController = true}) async {
    isLocationLoaded.value = false;
    staticMapImageUrl.value = LocationHelper.generateLocationPreviewImage(
      latitude: latt,
      longitude: long,
    );

    var address = await LocationHelper.getPlaceAddress(latt, long);
    if (isUpdateCurrentLocationController) {
      currentLocationController.value.text = address;
    }
    isLocationLoaded.value = true;
  }

  onAdd() async {
    await addData();
  }

  Future<void> addData() async {
    // isLoading.value = true;
    var service = AddRFIDService();

    String directionValue = selectedDirection.value == Direction.left
      ? 'left'
      : 'right';

    Map<String, dynamic> result = await service.addRsid(FormData({
      "user_id": await box.read(AppConstants.userId),
      "rsid": rsidController.value.text.trim(),
      "station_backward": stationFromController.value.text.trim(),
      "station_forward": stationCodeController.value.text.trim(),
      // "station_code_id": selectedStationCode.id,
      // "station_zone_id": selectedStationZone.id,

      "backward_station_id":selectedStationFrom.id,
      "forward_station_id":selectedStationCode.id,

      "direction": directionValue,
      "distance": numericInputValue.value,

      "current_location": currentLocationController.value.text.trim(),
      "latitude": selectedPlace.value.latitude,
      "longitude": selectedPlace.value.longitude,
      "note": noteController.value.text.trim(),
    }));

    if (result["success"] == 1) {
      RFIDModel rsidModel = RFIDModel.fromJson(result["data"]);
      if (rsidModel.success!) {
        Get.back();
        AppConstants.displaySuccessfulSnackbar(rsidModel.message!);
        rsidController.value.clear();
        stationCodeController.value.clear();
        stationFromController.value.clear();
        stationZoneController.value.clear();
        currentLocationController.value.clear();
        noteController.value.clear();
      } else {
        AppConstants.displayErrorSnackbar(rsidModel.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }

    // isLoading.value = false;
  }

  Future<void> getRFIDById() async {
    isLoading.value = true;
    var service = AddRFIDService();

    Map<String, dynamic> result =
        await service.getRFIDById(editRsidModel.value.id!);

    if (result["success"] == 1) {
      RFIDListModel rsidModel = RFIDListModel.fromSingleJson(result["data"]);
      if (rsidModel.success!) {
        editRFIDPopulate(rsidModel.rfidData);
        await getUserById(rsidModel.rfidData.userId!);
        selectedPlace.value = PlaceLocation(
            latitude: rsidModel.rfidData.latitude,
            longitude: rsidModel.rfidData.longitude,
            address: "");
      } else {
        AppConstants.displayErrorSnackbar(rsidModel.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }

    isLoading.value = false;
  }

  Future<void> getUserById(int userId) async {
    var service = SignupService();
    Map<String, dynamic> result = await service.getUserById(userId);

    if (result["success"] == 1) {
      UserListModel userData = UserListModel.fromSingleJson(result["data"]);
      if (userData.success!) {
        print("${userData.userData.toJson()}");
        userModel.value = userData.userData;
        // ConstantClass.displaySuccessfulSnackbar(userData.message!);
      } else {
        AppConstants.displayErrorSnackbar(userData.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
  }

  // Future<void> getStationZones() async {
  //   if (stationListStore.isNotEmpty) {
  //     return;
  //   }
  //   isStationListLoading.value = true;
  //   var service = AddRFIDService();
  //   Map<String, dynamic> result = await service.getStationZones();

  //   if (result["success"] == 1) {
  //     StationZones stationZones = StationZones.fromJson(result["data"]);
  //     if (stationZones.success!) {
  //       stationListStore.value = stationZones.stationZones;
  //       stationList.value = stationListStore;
  //     } else {
  //       ConstantClass.displayErrorSnackbar(stationZones.message!);
  //     }
  //   } else {
  //     ConstantClass.displaySomethingWentWrongSnackbar();
  //   }
  //   isStationListLoading.value = false;
  // }

  Future<void> getZonalHeadquarters() async {
    if (zonalListStore.isNotEmpty) {
      return;
    }
    isStationTypeLoading.value = true;
    var service = AddRFIDService();
    Map<String, dynamic> result = await service.getZonalHeadQuarters();

    if (result["success"] == 1) {
      ZonalHeadquarters zones = ZonalHeadquarters.fromJson(result["data"]);
      if (zones.success!) {
        zonalListStore.value = zones.zonalHeadquarters;
        zonalList.value = zonalListStore;
      } else {
        AppConstants.displayErrorSnackbar(zones.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
    isStationTypeLoading.value = false;
  }

  Future<void> getStationCodes() async {
    if (stationCodeListStore.isNotEmpty) {
      return;
    }
    isStationTypeLoading.value = true;
    var service = AddRFIDService();
    Map<String, dynamic> result = await service.getStationCode();

    if (result["success"] == 1) {
      StationCodes codes = StationCodes.fromJson(result["data"]);
      if (codes.success!) {
        stationCodeListStore.value = codes.stationCodes;
        stationCodeList.value = stationCodeListStore;
      } else {
        AppConstants.displayErrorSnackbar(codes.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
    isStationTypeLoading.value = false;
  }

  Future<void> getStationFrom() async {
    if (stationFromListStore.isNotEmpty) {
      return;
    }
    isStationTypeLoading.value = true;
    var service = AddRFIDService();
    Map<String, dynamic> result = await service.getStationCode();

    if (result["success"] == 1) {
      StationCodes codes = StationCodes.fromJson(result["data"]);
      if (codes.success!) {
        stationFromListStore.value = codes.stationCodes;
        stationFromList.value = stationFromListStore;
      } else {
        AppConstants.displayErrorSnackbar(codes.message!);
      }
    } else {
      AppConstants.displaySomethingWentWrongSnackbar();
    }
    isStationTypeLoading.value = false;
  }
}
