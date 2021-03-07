import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;

// const GOOGLE_API_KEY = 'AIzaSyDq40kL5RrLefHsh2oWfV9rFSePqBLbG_M';

const MAPBOX_API_KEY =
    'pk.eyJ1Ijoic3llZGRhbml5YWxhbGkyMCIsImEiOiJjamxhb3hydWowMnllM2t1YTVhejdsd3VjIn0.Rok46AMjBv4lwrs6K-nGLA';

const MAP_ZOOM = '15.25';
const MAP_SIZE = '600x300';

//Can be a through z, 0 through 99, or a valid Maki icon.
// If a letter is requested, it will be rendered in uppercase only
// (https://labs.mapbox.com/maki-icons/)
const MAP_LABEL = 'embassy';
const MAP_Marker_Color = 'f74e4e';

// You can change your theme style from here
const selectThemeStyle = Map_Theme.streets;

// You can change your theme icon from here
const selectIconSize = Map_Icon_Size.large;

enum Map_Theme { dark, light, streets, satellite }
enum Map_Icon_Size { small, large }

String get selectTheme {
  switch (selectThemeStyle) {
    case Map_Theme.dark:
      return 'dark-v10';
    case Map_Theme.light:
      return 'light-v10';
    case Map_Theme.streets:
      return 'streets-v11';
    case Map_Theme.satellite:
      return 'satellite-v9';
    default:
      return 'light';
  }
}

String get markerIconSize {
  switch (selectIconSize) {
    case Map_Icon_Size.small:
      return 's';
    case Map_Icon_Size.large:
      return 'l';
    default:
      return 'l';
  }
}

class LocationHelper {
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://api.mapbox.com/styles/v1/mapbox/$selectTheme/static/pin-$markerIconSize-$MAP_LABEL+$MAP_Marker_Color($longitude,$latitude)/$longitude,$latitude,$MAP_ZOOM/$MAP_SIZE?access_token=$MAPBOX_API_KEY';

    // 'https://maps.googleapis.com/maps/api/staticmap?'
    //   'center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap'
    //   '&markers=color:red%7Clabel:C%$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json?access_token=$MAPBOX_API_KEY';

    final response = await http.get(url);

      // print(json.decode(response.body)["features"][0]["place_name"]);

    return json.decode(response.body)["features"][0]["place_name"]??"No address line available";
  }
}
