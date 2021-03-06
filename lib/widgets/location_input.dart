import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../screens/map_screen.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _imagePreviewUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locData.latitude, longitude: locData.longitude);
    // print(locData.longitude);
    // print(locData.latitude);
    setState(() {
      _imagePreviewUrl = staticMapImageUrl;
      print(_imagePreviewUrl);
    });
  }


  // We are using async here because we want to get the selected location back when the screen pop (we can use .then() method or simply use await)
  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        //It will make the cross icon instead of (back icon) for back
        fullscreenDialog: true,
        builder: (ctx) =>
            MapScreen(
              isSelecting: true,
            ),
      ),
    );

    if (selectedLocation == null) {
      return;
    }
    print(selectedLocation);
    //  ....
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 170,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        child: _imagePreviewUrl == null
            ? Text('No Location Chosen')
            : Image.network(
          _imagePreviewUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _getCurrentUserLocation,
            icon: Icon(Icons.location_on),
            label: Text(
              'Current Location',
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),
            ),
          ),
          TextButton.icon(
            onPressed: _selectOnMap,
            icon: Icon(Icons.map),
            label: Text(
              'Select on Map',
              style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor),
            ),
          ),
        ],
      )
    ]);
  }
}
