import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/WidgetsItems.dart';
import '../../components/custom_decoration.dart';
import '../../model/PlaceModel.dart';
import '../../utility/colors_constant.dart';
import '../../utility/constant_class.dart';
import '../../utility/map_utility.dart';
import 'add_rsid_controller.dart';
import 'map_screen/map_view.dart';

class AddRFIDView extends GetView<AddRFIDController> {
  @override
  var controller = Get.put(AddRFIDController());

  final _formKey = GlobalKey<FormState>();

  bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.primary,
      body: Obx(
        () => SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              controller.isReadonly.value
                                  ? "RFID Details"
                                  : "Add RFID",
                              style: Get.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  controller: controller.rsidController.value,
                                  readOnly: controller.isReadonly.value,
                                  keyboardType: TextInputType.name,
                                  validator: (username) {
                                    if (username!.isEmpty) {
                                      return "Enter RFID";
                                    }

                                    return null;
                                  },
                                  decoration: CustomInputDecoration(
                                    "Enter RFID*",
                                    null,
                                    labelText: controller.isReadonly.value
                                        ? "RFID"
                                        : "Enter RFID*",
                                  ),
                                  autofocus: false,
                                  style: Get.textTheme.bodySmall!
                                      .copyWith(color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Visibility(
                                visible: !controller.isReadonly.value,
                                child: Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () async {
                                      String barcodeScanRes =
                                          await FlutterBarcodeScanner
                                              .scanBarcode("#ff6666", "Cancel",
                                                  true, ScanMode.BARCODE);

                                      if (barcodeScanRes != "-1") {
                                        controller.rsidController.value.text =
                                            barcodeScanRes;
                                      }
                                    },
                                    icon: const Icon(
                                      Icons
                                          .read_more_outlined, //changes made to the barcode_reader for app to run
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // TextFormField(
                          //   // readOnly: controller.isReadonly.value,
                          //   readOnly: true,
                          //   controller: controller.stationZoneController.value,
                          //   // keyboardType: TextInputType.name,
                          //   keyboardType: TextInputType.multiline,
                          //   maxLines: null,
                          //   validator: (username) {
                          //     if (username!.isEmpty) {
                          //       return "Enter Station Zone";
                          //     }

                          //     return null;
                          //   },
                          //   onTap: () {
                          //     if (!controller.isReadonly.value) {
                          //       showBottomModalSheet(StationType.zone);
                          //     }
                          //   },
                          //   decoration: CustomInputDecoration(
                          //     "Enter Station Zone*",
                          //     labelText: controller.isReadonly.value
                          //         ? "Station Zone"
                          //         : "Enter Station Zone*",
                          //     null,
                          //     suffixIcon: const Icon(
                          //       Icons.keyboard_arrow_down_sharp,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          //   autofocus: false,
                          //   style: Get.textTheme.bodySmall!.copyWith(
                          //     color: Colors.white,
                          //   ),
                          //   textInputAction: TextInputAction.next,
                          // ),


                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            // readOnly: controller.isReadonly.value,
                            readOnly: true,
                            controller: controller.stationFromController.value,
                            keyboardType: TextInputType.name,
                            validator: (username) {
                              if (username!.isEmpty) {
                                return "From Station";
                              }

                              return null;
                            },
                            onTap: () {
                              if (!controller.isReadonly.value) {
                                showBottomModalSheet(StationType.from);
                              }
                            },
                            decoration: CustomInputDecoration(
                              "From Station*",
                              labelText: controller.isReadonly.value
                                  ? "Station From"
                                  : "Select From Station*",
                              null,
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.white,
                              ),
                            ), //baki thik h kya?

                            autofocus: false,
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                            textInputAction: TextInputAction.next,
                          ),



                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            // readOnly: controller.isReadonly.value,
                            readOnly: true,
                            controller: controller.stationCodeController.value,
                            keyboardType: TextInputType.name,
                            validator: (username) {
                              if (username!.isEmpty) {
                                return "Enter Station To";
                              }

                              return null;
                            },
                            onTap: () {
                              if (!controller.isReadonly.value) {
                                showBottomModalSheet(StationType.code);
                              }
                            },
                            decoration: CustomInputDecoration(
                              "Enter Station To*",
                              labelText: controller.isReadonly.value
                                  ? "Station To"
                                  : "Enter Station To*",
                              null,
                              suffixIcon: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.white,
                              ),
                            ), //baki thik h kya?

                            autofocus: false,
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),


                          /* +++++++++++++++++++++++++++++++++++ */

                          // Radio buttons for "left" and "right" options
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.selectedDirection.value = Direction.left;
                                },
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'left',
                                      groupValue: controller.selectedDirection.value == Direction.left
                                          ? 'left'
                                          : 'right',
                                      onChanged: (value) {
                                        controller.selectedDirection.value =
                                            value == 'left' ? Direction.left : Direction.right;
                                      },
                                    ),
                                    const Text(
                                      'Left',
                                      style: TextStyle(color: Colors.white), // White text color
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.selectedDirection.value = Direction.right;
                                },
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'right',
                                      groupValue: controller.selectedDirection.value == Direction.left
                                          ? 'left'
                                          : 'right',
                                      onChanged: (value) {
                                        controller.selectedDirection.value =
                                            value == 'left' ? Direction.left : Direction.right;
                                      },
                                    ),
                                    const Text(
                                      'Right',
                                      style: TextStyle(color: Colors.white), // White text color
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),


                          // Numeric input field (Distance Meter)
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            readOnly: controller.isReadonly.value,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Distance in Meter";
                              }
                              if (!isNumeric(value)) {
                                return "Invalid Distance (Enter numeric value)";
                              }
                              // Add any additional validation logic here if needed
                              return null;
                            },
                            onChanged: (value) {
                              controller.numericInputValue.value = value;
                            },
                            decoration: CustomInputDecoration(
                              "Enter Distance (Meter)*",
                              null,
                              labelText: "Enter Distance (Meter)*",
                            ),
                            autofocus: false,
                            style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          /* +++++++++++++++++++++++++++++++++++ */



                          controller.isLocationLoaded.value
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                          controller.staticMapImageUrl.value),
                                      Positioned(
                                          top: 0,
                                          right: -20,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              MapUtils.redirect(
                                                  latitude: controller
                                                      .selectedPlace
                                                      .value
                                                      .latitude!,
                                                  longitude: controller
                                                      .selectedPlace
                                                      .value
                                                      .longitude!);
                                            },
                                            elevation: 2.0,
                                            fillColor: ColorsConstant.primary,
                                            padding: const EdgeInsets.all(5.0),
                                            shape: const CircleBorder(),
                                            child: const Icon(
                                              Icons.directions,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 20,
                          ),
                          controller.isReadonly.value
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: RoundedLoadingButton(
                                          height: 40,
                                          color: ColorsConstant.orange,
                                          borderRadius: 10,
                                          controller:
                                              controller.currentLocationButton,
                                          onPressed: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            await controller
                                                .getCurrentLocation();
                                            controller.currentLocationButton
                                                .reset();
                                          },
                                          child: Text(
                                            'Get Current Location',
                                            style: Get.textTheme.bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.backgroundColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: RoundedLoadingButton(
                                        height: 40,
                                        color: ColorsConstant.orange,
                                        borderRadius: 10,
                                        controller:
                                            controller.pickLocationButton,
                                        onPressed: () async {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          LatLng? pickedLocation = await Get.to(
                                            () => MapView(),
                                            arguments:
                                                controller.selectedPlace.value,
                                          );

                                          if (pickedLocation != null) {
                                            controller.selectedPlace.value =
                                                PlaceLocation(
                                                    latitude:
                                                        pickedLocation.latitude,
                                                    longitude: pickedLocation
                                                        .longitude);
                                            controller.updateLocationPreview(
                                              pickedLocation.latitude,
                                              pickedLocation.longitude,
                                            );
                                          }

                                          controller.pickLocationButton.reset();
                                        },
                                        child: Text(
                                          'Pick Location',
                                          style:
                                              Get.textTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Get.theme.backgroundColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: controller.isReadonly.value ? 0 : 20,
                          ),
                          TextFormField(
                            controller:
                                controller.currentLocationController.value,
                            readOnly: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            validator: (username) {
                              if (username!.isEmpty) {
                                return "Enter Current Location";
                              }

                              return null;
                            },
                            decoration: CustomInputDecoration(
                              "Enter Current Location*",
                              null,
                              labelText: controller.isReadonly.value
                                  ? "Location"
                                  : "Enter Current Location*",
                            ),
                            autofocus: false,
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            readOnly: controller.isReadonly.value,
                            controller: controller.noteController.value,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            decoration: CustomInputDecoration(
                              "Enter Note",
                              null,
                              // labelText: "Enter Note",
                            ),
                            autofocus: false,
                            style: Get.textTheme.bodySmall!
                                .copyWith(color: Colors.white),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Visibility(
                            visible: controller.isReadonly.value,
                            child: TextFormField(
                              readOnly: controller.isReadonly.value,
                              initialValue:
                                  "Name: ${controller.userModel.value.firstName} ${controller.userModel.value.lastName}\nContactNo: ${controller.userModel.value.mobile}\nCompanyName: ${controller.userModel.value.companyName ?? '-'}\nCompanyEmail: ${controller.userModel.value.companyEmail ?? '-'}\nCompanyAddress: ${controller.userModel.value.companyAddress ?? '-'}",
                              keyboardType: TextInputType.multiline,
                              maxLines: 7,
                              decoration: CustomInputDecoration(
                                "Agent Details",
                                null,
                                labelText: "Agent Details",
                              ),
                              autofocus: false,
                              style: Get.textTheme.bodySmall!
                                  .copyWith(color: Colors.white),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Visibility(
                            visible: controller.isReadonly.value,
                            child: const SizedBox(
                              height: 30,
                            ),
                          ),
                          controller.isReadonly.value
                              ? const SizedBox()
                              : SizedBox(
                                  width: 200,
                                  child: RoundedLoadingButton(
                                    height: 40,
                                    color: ColorsConstant.orange,
                                    borderRadius: 30,
                                    controller: controller.addButtonController,
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        await controller.onAdd();
                                      }
                                      controller.addButtonController.reset();
                                    },
                                    child: Text(
                                      'Save',
                                      style: Get.textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void showBottomModalSheet(StationType stationType) {
    if (stationType == StationType.zone) {
      // controller.getStationZones();
      controller.getZonalHeadquarters();
      controller.zonalList.value = [...controller.zonalListStore];
      debugPrint(
          "Station Length: ${controller.zonalList.length} / ${controller.zonalListStore.length}");
    } else if (stationType == StationType.from) {
      controller.getStationFrom();
      controller.stationFromList.value = [...controller.stationFromListStore];

      debugPrint(
          "Station Length: ${controller.stationFromList.length} / ${controller.stationFromListStore.length}");
    } else if (stationType == StationType.code) {
      controller.getStationCodes();
      controller.stationCodeList.value = [...controller.stationCodeListStore];

      debugPrint(
          "Station Length: ${controller.stationCodeList.length} / ${controller.stationCodeListStore.length}");
    }

    Get.bottomSheet(
      Obx(
        () => SafeArea(
          child: Container(
            height: Get.height,
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (stationType == StationType.zone) {
                        controller.zonalList.value = [
                          ...controller.zonalListStore.value.where((zone) =>
                              zone.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                        ];
                      } else if (stationType == StationType.from) {
                        controller.stationFromList.value = [
                          ...controller.stationFromListStore.value.where(
                              (zone) => zone.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                        ];
                      } else if (stationType == StationType.code) {
                        controller.stationCodeList.value = [
                          ...controller.stationCodeListStore.value.where(
                              (zone) => zone.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                        ];
                      }
                    } else {
                      if (stationType == StationType.zone) {
                        controller.zonalList.value = [
                          ...controller.zonalListStore
                        ];
                      } else if (stationType == StationType.from) {
                        controller.stationFromList.value = [
                          ...controller.stationFromListStore
                        ];
                      } else if (stationType == StationType.code) {
                        controller.stationCodeList.value = [
                          ...controller.stationCodeListStore
                        ];
                      }
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorsConstant.searchTextFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    //border: const OutlineInputBorder(),
                    hintText:
                        'Search Station ${stationType == StationType.from ? '(From)' : '(To)'}',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // ignore: avoid_unnecessary_containers
                Expanded(
                  child: controller.isStationTypeLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : stationType == StationType.from
                          ? /* WidgetItems.stationZoneItem(
                              controller.zonalList,
                              onTapCallback: (zoneHeadquarter, zone) {
                                Get.back(closeOverlays: false);
                                debugPrint(zone.name!);
                                controller.selectedStationZone = zone;
                                controller.stationZoneController.value.text =
                                    "${controller.selectedStationZone.name!}-${zoneHeadquarter.name}";
                              },
                            ) */
                            WidgetItems.stationCodeItem(
                              controller.stationFromList,
                              onTapCallback: (from) {
                                Get.back(closeOverlays: false);
                                debugPrint(from.name!);
                                controller.selectedStationFrom = from;
                                controller.stationFromController.value.text =
                                    from.name!;
                              },
                            )
                          : WidgetItems.stationCodeItem(
                              controller.stationCodeList,
                              onTapCallback: (code) {
                                Get.back(closeOverlays: false);
                                debugPrint(code.name!);
                                controller.selectedStationCode = code;
                                controller.stationCodeController.value.text =
                                    code.name!;
                              },
                            ),
                ),

                const Divider(),
              ],
            ),
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      isScrollControlled: true,
    );
    // showModalBottomSheet(
    //   context: context,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(
    //       top: Radius.circular(15.0),
    //     ),
    //   ),
    //   builder: ((context) {
    //     return Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           TextField(
    //             //     onChanged: (value) => _runFilter(value),
    //             decoration: InputDecoration(
    //               filled: true,
    //               fillColor: ColorsConstant.searchTextFieldColor,
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(15),
    //                 borderSide: BorderSide.none,
    //               ),
    //               prefixIcon: const Icon(Icons.search),
    //               //border: const OutlineInputBorder(),
    //               hintText: 'Search Station Code',
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           // ignore: avoid_unnecessary_containers
    //           Expanded(
    //             child: ListView.builder(
    //               itemCount: controller.searchTerms.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return Container(
    //                   child: ListTile(
    //                     title: Text(controller.searchTerms[index]),
    //                   ),
    //                 );
    //               },
    //             ),
    //           ),

    //           const Divider(),
    //         ],
    //       ),
    //     );
    //   }),
    // );
  }
}
