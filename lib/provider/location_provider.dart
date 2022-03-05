import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_service_provider/helpers/location_helper.dart';
import 'package:vehicle_service_provider/models/http_exception.dart';

class Location {
  final String title;
  final double latitude;
  final double longitude;
  final String address;
  final num no;
  final String id;
  final String name;

  Location(
      {this.title,
      this.longitude,
      this.latitude,
      this.id,
      this.address,
      this.no,
      this.name});
}

class LocationProvider with ChangeNotifier {
  final String token;
  final String userId;

  LocationProvider(this.userId, this.token);

  List<Location> _itemList = [];

  List<Location> get getItemsList {
    return [..._itemList];
  }

  Future<void> addLocation(
      {double long,
      double lat,
      num number,
      String address,
      String name,
      String locTitle}) async {
    //String address = await LocationHelper.getAddress(lat, long);
    final String myUrl =
        'https://vahicleserviceprovider-default-rtdb.firebaseio.com/uploadedLocations.json?auth=$token';
    final response = await http.post(myUrl,
        body: json.encode({
          "latitude": lat,
          "longitude": long,
          "creatorId": userId,
          "number": number,
          "address": address,
          "name": name,
          "title": locTitle,
        }));
    final newLocation = Location(
      longitude: long,
      latitude: lat,
      id: json.decode(response.body)['name'],
      title: locTitle,
      no: number,
      address: address,
    );
    _itemList.add(newLocation);
    notifyListeners();
  }

  Future<void> fetchAndSet(bool isFilter) async {
    final String filtering =
        isFilter ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    final String myUrl =
        'https://vahicleserviceprovider-default-rtdb.firebaseio.com/uploadedLocations.json?auth=$token&$filtering';
    final response = await http.get(myUrl);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Location> extractedList = [];
    extractedData.forEach((key, value) {
      extractedList.add(Location(
        title: value['title'],
        address: value['address'],
        no: value['number'],
        longitude: value['longitude'],
        latitude: value['latitude'],
        name: value['name'],
        id: key,
      ));
    });
    _itemList = extractedList;
    notifyListeners();
  }

  Location getElementById(String elementId) {
    return _itemList.firstWhere((element) => element.id == elementId);
  }

  Future<void> deleteItem(String id) async {
    final String myUrl =
        'https://vahicleserviceprovider-default-rtdb.firebaseio.com/uploadedLocations/$id.json?auth=$token';
    final itemIndex = _itemList.indexWhere((element) => element.id == id);
    var itemAtIndex = _itemList[itemIndex];
    _itemList.removeAt(itemIndex);
    notifyListeners();
    final response = await http.delete(myUrl);
    if (response.statusCode > 400) {
      _itemList.insert(itemIndex, itemAtIndex);
      notifyListeners();
      throw HttpException("Deletion failed");
    }
    itemAtIndex = null;
  }
}
