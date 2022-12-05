import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/map_page.dart';
import 'package:geolocator/geolocator.dart';

import 'MapClasses/MapObject.dart';
import 'MapClasses/ZoomContainer.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({super.key});

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  // creating variable for saving location coordinates
  //var locationMessage = "";
  Offset offset = Offset(-0.3500, -0.7500);
  Position? pos;
  double lat = 51.3410600;
  double? long;
  bool hasArrived = false;
  Position? _currentPosition;
  // function that gets the current location using Geolocator API
  // set the location accuracy as accurate as possible for navigation purpose
  // print out the latitude and longitude with restricted (6) decimal numbers
  _getCurrentLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        _currentPosition = position;
        offset = Offset((_currentPosition?.latitude)! - 51,
            (_currentPosition?.longitude)! - 12);
        if (_currentPosition!.latitude <= lat + 0.0000100 &&
                _currentPosition!.latitude >= lat - 0.0000100
            /*&& _currentPosition!.longitude <= long + 0.0000100 &&
            _currentPosition!.longitude >= long - 0.0000100*/
            ) {
          hasArrived = true;
        }
        print(
            "Lat: ${_currentPosition?.latitude},\nLong: ${_currentPosition?.longitude}");
      });
    });
  }

  void _determinePosition() async {
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
    Position currentPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      lat = currentPos.latitude;
      long = currentPos.longitude;
      pos = currentPos;
    });
  }

  // build the context for displaying the current coordinates
  // returning a visual scaffold for Material Design widgets
/*  @override
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
            if (hasArrived)
              const AlertDialog(
                title: Text("You have arrived"),
                content: Text("You have arrived"),
              ),
            Text(
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                "LATCurrent: ${pos?.latitude.toStringAsFixed(7)},\nLNGCurrent: ${pos?.longitude.toStringAsFixed(7)}"),
            Text(
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                "LAT: ${_currentPosition?.latitude.toStringAsFixed(7)}, \nLNG: ${_currentPosition?.longitude.toStringAsFixed(7)}"),
            const Icon(Icons.location_on, size: 60, color: Colors.blue),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Get user Location",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
*/ /*             Text(
              "$locationMessage\n",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ), */ /*
            ElevatedButton(
              key: Key('getCurrent'),
                onPressed: () {
                  _determinePosition();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CampusMap()));
                },
                child: const Text("Get Current Location")),
            const SizedBox(height: 20,),
            ElevatedButton(
              key: Key('getLive'),
              onPressed: () {
                _getCurrentLocation();
              },
              child: const Text("Get Live Location"),
            )
          ],
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus navigator map"),
      ),
      body: Center(
        child: ZoomContainer(
          key: const Key("zoomContainer"),
          zoomLevel: 1,
          imageProvider: Image.asset("assets/map.png").image,
          objects: [
            MapObject(
              child: Container(
                color: Colors.red,
              ),
              //offset: const Offset(-0.21, 0.31),
              offset: offset,
              size: const Size(15, 15),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          _locationPermission();
          _getLiveLocation();
          _updateSquareDx(_currentPosition.longitude);
          _updateSquareDy(_currentPosition.latitude);
        },
        backgroundColor: Colors.blue,
        child: const Text('Go'),
      ),*/
    );
  }
}
