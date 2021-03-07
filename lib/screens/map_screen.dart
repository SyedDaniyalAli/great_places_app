import 'dart:math';

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
        address: null
      ),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  MapboxMapController _controller;


  //Remove Previous Marker
  void removePreviousMarker(Point<double> point, LatLng position)
  {
    _controller.removeSymbol(Symbol(point.toString(), SymbolOptions(
      // You retrieve this value from the Mapbox Studio
      iconImage: 'embassy-15',
      iconColor: '#006992',

      // YES, YOU STILL NEED TO PROVIDE A VALUE HERE!!!
      geometry: position ??
          LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
    ),));
  }

  // Selecting Location ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  void _selectLocation(Point<double> point, LatLng position) {
    setState(() {
      // print("Point: " + point.toString() + "Position: " + position.toString());

      _pickedLocation = position;


      removePreviousMarker(point, position);

      // Add a icon denoting current user location
      if (position != null && widget.isSelecting) {
        print("MapScreen: " +
            position.longitude.toString() +
            "," +
            position.longitude.toString());
        _controller.addSymbol(
          SymbolOptions(
            // You retrieve this value from the Mapbox Studio
            iconImage: 'embassy-15',
            iconColor: '#006992',

            // YES, YOU STILL NEED TO PROVIDE A VALUE HERE!!!
            geometry: position ??
                LatLng(
                  widget.initialLocation.latitude,
                  widget.initialLocation.longitude,
                ),
          ),
        );
      }
    });
  }

  // Future<void> _addMarker(Point<double> point, LatLng position) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              //if no data then disable the button
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      // the location will be return from here (_pickedLocation)
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: MapboxMap(
        accessToken: MAPBOX_API_KEY,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),

        //On Tap ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        onMapLongClick: widget.isSelecting ? _selectLocation : null,

        // On Map Created ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        onMapCreated: (MapboxMapController controller) {
          // You can either use the moveCamera or animateCamera, but the former
          // causes a sudden movement from the initial to 'new' camera position,
          // while animateCamera gives a smooth animated transition
          _controller = controller;
          // _selectLocation(
          //     //Fake Points
          //     Point(2, 3),
          //     LatLng(widget.initialLocation.latitude,
          //         widget.initialLocation.longitude));

          // controller.animateCamera(
          //   CameraUpdate.newLatLng(
          //     LatLng(widget.initialLocation.latitude,
          //         widget.initialLocation.longitude),
          //   ),
          // );
        },
      ),
    );
  }
}
