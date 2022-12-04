import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mockito/mockito.dart';
import 'MapClasses/MapObject.dart';
import 'MapClasses/ZoomContainer.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';

void main() {
  runApp(Campus());
}

class Campus extends StatefulWidget {
  const Campus({super.key});

  @override
  CampusMap createState() => CampusMap();
}

//This class initializes the map that we provide as a .png image
//it as well, sets a MapObject of color red, at a preset offset and of our desired
//size to be placed on the image
class CampusMap extends State<Campus> {
  Position? pos;
  double lat = 51.3410600;
  double? long;
  double dx = 0, dy = 0;

  bool hasArrived = false;
  Position _currentPosition = Position(
      longitude: 0,
      latitude: 0,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      timestamp: DateTime(0));
  _getLiveLocation() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        _currentPosition = position;
        if (_currentPosition.latitude <= lat + 0.0000100 &&
            _currentPosition.latitude >= lat - 0.0000100) {
          hasArrived = true;
        }
      });
    });
  }

  Future<void> _updateSquareDx(double long) async {
    double width = MediaQuery.of(context).size.width;
    setState(() {
      dx = (long * width) / 360;
    });
    print(dx);
  }

  Future<void> _updateSquareDy(double lat) async {
    double height = MediaQuery.of(context).size.height;
    setState(() {
      dy = (lat * height) / 180;
    });
    print(dy);
  }

  _locationPermission() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus navigator map"),
      ),
      body: Center(
        child: ZoomContainer(
          zoomLevel: 1,
          imageProvider: Image.asset("assets/map.png").image,
          objects: [
            MapObject(
              child: Container(
                color: Colors.red,
              ),
              offset: Offset(dx, dy),
              size: const Size(15, 15),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _locationPermission();
          _getLiveLocation();
          _updateSquareDx(_currentPosition.longitude);
          _updateSquareDy(_currentPosition.latitude);
        },
        backgroundColor: Colors.blue,
        child: const Text('Go'),
      ),
    );
  }
}
