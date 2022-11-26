import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({super.key});

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  // creating variable for saving location coordinates
  var locationMessage = "";

  // function that gets the current location using Geolocator API
  // set the location accuracy as accurate as possible for navigation purpose
  // print out the latitude and longitude with restricted (6) decimal numbers
  void getCurrentLocation() async {
    Position? position;
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) {
/*       (position == null
          ? 'Unknown'
          : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}'); */
      setState(() {
        locationMessage =
            "Latitude: ${position.latitude.toStringAsFixed(6)}\nLongitude:${position.longitude.toStringAsFixed(6)}";
      });
    });
    //var lat = double.parse(position.latitude.toStringAsFixed(6));
    //var lon = double.parse(position.longitude.toStringAsFixed(6));
    /* setState(() {
      locationMessage = "Your Position:\nLatitude: $lat,\nLongitude: $lon";
    }); */
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    //Test if the location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error("Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //Permisions are denied forever, handle appropriately
      return Future.error(
          "Location permissions are permanently denied, we cannot request permissions.");
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  // build the context for displaying the current coordinates
  // returning a visual scaffold for Material Design widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LocationApp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 45, color: Colors.blue),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Get user Location",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "$locationMessage\n",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: const Text("Get Current Location"),
            )
          ],
        ),
      ),
    );
  }
}
