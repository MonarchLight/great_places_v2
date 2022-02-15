import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String pickedtitle, File pickedimage) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedimage,
      title: pickedtitle,
    );
    _items.add(newPlace);
    notifyListeners();
  }
}
