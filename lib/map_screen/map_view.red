import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_controller.txt';

class MapView extends GetView<MapController> {
  @override
  var controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Get Map Location",
        ),
      ),
      body: SafeArea(
        child: GoogleMap(
          // on below line setting camera position
          initialCameraPosition: controller.kGoogle,
          // on below line we are setting markers on the map
          markers: Set<Marker>.of(controller.markers),
          // on below line specifying map type.
          mapType: MapType.normal,
          // on below line setting user location enabled.
          myLocationEnabled: true,
          // on below line setting compass enabled.
          compassEnabled: true,
          // on below line specifying controller on map complete.
          onMapCreated: (GoogleMapController _controller) {
            controller.controllerMap.complete(_controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Location'),
        icon: const Icon(Icons.local_activity),
      ),
    );
  }
}
