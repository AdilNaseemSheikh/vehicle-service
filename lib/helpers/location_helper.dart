import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'AIzaSyDklmhmC0GFA5TfZNiTOP8IXMyoDQk53WM';

class LocationHelper {
  static String getImagePreview(double lat, double lng) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:V%7C$lat,$lng&key=$GOOGLE_API_KEY';
  }

  static Future<String> getAddress(double lat, double lng) async {
    final myUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(myUrl);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
