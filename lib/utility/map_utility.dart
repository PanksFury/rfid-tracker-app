import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  ///Redirect to the google map Location
  static Future<void> redirect(
      {required double latitude, required double longitude}) async {
    // String googleUrl =
    //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // if (await canLaunchUrl(Uri.parse(googleUrl))) {
    //   await launchUrl(Uri.parse(googleUrl));
    // } else {
    //   throw "Could not launch";
    // }

    try {
      final availableMaps = await MapLauncher.installedMaps;
      debugPrint(availableMaps
          .toString()); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

      await availableMaps.first.showMarker(
        coords: Coords(latitude, longitude),
        title: "",
      );
    } catch (e) {
      if (Platform.isAndroid || Platform.isIOS) {
        final appId = Platform.isAndroid
            ? 'com.google.android.apps.maps'
            : 'YOUR_IOS_APP_ID';
        final url = Uri.parse(
          Platform.isAndroid
              ? "market://details?id=$appId"
              : "https://apps.apple.com/app/id$appId",
        );
        launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }
}
