import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get item {
    // Returning Copy of _items
    return [..._items];
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation pickedLocation,
  ) async {

    //Getting address to save in database
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);

    final updateLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: updateLocation,
    );
    _items.add(newPlace);
    notifyListeners();

    //  Adding Data to SQFLite DataBase
    DBHelper.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location.latitude,
        'loc_lng': newPlace.location.longitude,
        'address': newPlace.location.address,

      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(latitude: item['loc_lat'], longitude: item['loc_lng'], address: item['address']),
            image: File(item['image']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
