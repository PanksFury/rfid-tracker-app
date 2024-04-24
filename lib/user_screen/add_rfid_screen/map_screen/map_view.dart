import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_controller.dart';

class MapView extends GetView<MapController> {
  @override
  var controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Pick Location"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: controller.pickedLocation.value == null
                  ? null
                  : () {
                      Navigator.of(context).pop(controller
                          .pickedLocation.value); //Return Picked Location
                    },
            ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(
                child: Text("Loading..."),
              )
            : GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.selectedLocation.value.latitude ?? 0,
                    controller.selectedLocation.value.longitude ?? 0,
                  ),
                  zoom: 16,
                ),
                onTap: (latLong) {
                  controller.pickedLocation.value = latLong;
                  print(
                      "Longitud: ${controller.pickedLocation.value!.longitude}, ${controller.pickedLocation.value!.latitude}");
                },
                markers: controller.pickedLocation.value == null
                    ? {}
                    : {
                        Marker(
                          markerId: const MarkerId('m1'),
                          position: controller.pickedLocation.value == null
                              ? LatLng(
                                  controller.selectedLocation.value.latitude!,
                                  controller.selectedLocation.value.longitude!)
                              : controller.pickedLocation.value!,
                        ),
                      },
              ),
      ),
    );
  }
}
