import 'dart:io';

import 'package:flutter/foundation.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get item {
    // Returning Copy of _items
    return [..._items];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: null,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
  }
}
