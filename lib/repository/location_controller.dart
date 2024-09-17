import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../singleton.dart';

class LocationModel {
  double? latitude;
  double? longitude;
  LocationModel(this.latitude, this.longitude);
}

class LocationController {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Singleton _instance = Singleton();

  Future getCurrentLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      getLocation();
      return;
    } else {
      LocationPermission permission = await Geolocator.requestPermission();
      print(permission);
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print(permission);
        print("hello");
        showAlertDialog(context);
      } else {
        getLocation();
      }
    }
  }

  double calculateDistanceInKiloMeters(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    var distanceInKiloMeter = 12742 * asin(sqrt(a));
    return distanceInKiloMeter;
  }

  //List<Address> results = [];
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _instance.currentLat = position.latitude;
    _instance.currentLng = position.longitude;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Enable"),
      onPressed: () async {
        late LocationSettings locationSettings;

        if (defaultTargetPlatform == TargetPlatform.android) {
          print("apple");
          await Geolocator.openLocationSettings();
          locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100,
            forceLocationManager: true,
            intervalDuration: const Duration(seconds: 10),
          );
        } else if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS) {
          print("apple");
          await Geolocator.openLocationSettings();
          locationSettings = AppleSettings(
            accuracy: LocationAccuracy.high,
            activityType: ActivityType.fitness,
            distanceFilter: 100,
            pauseLocationUpdatesAutomatically: true,
            // Only set to true if our app will be started up in the background.
            showBackgroundLocationIndicator: false,
          );
        } else {
          locationSettings = const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100,
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enable Location"),
      content:
          Text("Location need to be enabled to use Google map functionality!"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
