import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:blips/models/user_location.dart';

class LocationProvider with ChangeNotifier {
  late UserLocation userLocation = UserLocation(latitude: 0.0, longitude: 0.0);
  List<Placemark> placemarks = <Placemark>[];
  Location location = Location();



  LocationProvider() {
    initialize();
  }

  Future<void> getPlacemarks(UserLocation userLocation) async {
   placemarks = await placemarkFromCoordinates(userLocation.latitude!, userLocation.longitude!);

  }

  Future<void> initialize() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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
    location.getLocation().then((data) {
      userLocation =
          UserLocation(latitude: data.latitude, longitude: data.longitude);
      getPlacemarks(userLocation);
    });
  }
}
