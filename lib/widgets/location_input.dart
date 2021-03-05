import 'package:flutter/material.dart';
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
      _imagePreviewUrl= staticMapImageUrl;
      print(_imagePreviewUrl);
    });
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
            onPressed: () {},
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
