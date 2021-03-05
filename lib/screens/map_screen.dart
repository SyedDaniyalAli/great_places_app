import 'package:flutter/material.dart';
import '../models/place.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

const MAPBOX_API_KEY =
    'pk.eyJ1Ijoic3llZGRhbml5YWxhbGkyMCIsImEiOiJjamxhb3hydWowMnllM2t1YTVhejdsd3VjIn0.Rok46AMjBv4lwrs6K-nGLA';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  //Adding const because we can't change the value in runtime once it is assign to the constructor
  MapScreen(
      {this.initialLocation = const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
      ),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
      ),
      body: MapboxMap(
        accessToken: MAPBOX_API_KEY,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),
      ),
    );
  }
}
