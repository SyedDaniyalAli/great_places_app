import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../screens/map_screen.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _imagePreviewUrl;

  //Checking Permission for Location
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;



  void _showPreview(double latitude, double longitude) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: latitude, longitude: longitude);
    // print(locData.longitude);
    // print(locData.latitude);
    setState(() {
      _imagePreviewUrl = staticMapImageUrl;
      print(_imagePreviewUrl);
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
      print("Location Input: "+_locationData.latitude.toString()+","+_locationData.longitude.toString());
      _showPreview(_locationData.latitude, _locationData.longitude);
      widget.onSelectPlace(_locationData.latitude, _locationData.longitude);
    } catch (e) {
      return;
    }
  }

  // We are using async here because we want to get the selected location back when the screen pop (we can use .then() method or simply use await)
  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        //It will make the cross icon instead of (back icon) for back
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
          initialLocation: PlaceLocation(latitude: locData.latitude, longitude: locData.longitude, address: null),
        ),
      ),
    );

    if (selectedLocation == null) {
      return;
    }
    print("Location Input: "+selectedLocation.latitude.toString()+","+selectedLocation.longitude.toString());
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
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
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          TextButton.icon(
            onPressed: _selectOnMap,
            icon: Icon(Icons.map),
            label: Text(
              'Select on Map',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      )
    ]);
  }
}
