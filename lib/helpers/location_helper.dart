import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utility/constant_class.dart';

var GOOGLE_API_KEY = AppConstants.GOOGLE_API_KEY;

class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=18&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY",
    );

    final response = await http.get(url);
    log("RESP: $url | ${json.decode(response.body)['results'][0]['formatted_address']}");
    return json.decode(response.body)['results'][0]['formatted_address'];

    //https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding
  }
}
