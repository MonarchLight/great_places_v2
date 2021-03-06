import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helpers.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedtitle,
    File pickedimage,
    PlaceLocation pickedLocation,
  ) async {
    final addressLoct = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updateLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: addressLoct);
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedimage,
      title: pickedtitle,
      location: updateLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": newPlace.location.latitude,
      "loc_lng": newPlace.location.longitude,
      "address": newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData("user_places");
    _items = dataList
        .map((i) => Place(
              id: i["id"],
              image: File(i["image"]),
              title: i["title"],
              location: PlaceLocation(
                  latitude: i["loc_lat"],
                  longitude: i["loc_lng"],
                  address: i["address"]),
            ))
        .toList();
    notifyListeners();
  }
}
