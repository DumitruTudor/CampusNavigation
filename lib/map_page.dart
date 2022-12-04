import 'package:flutter/material.dart';
import 'MapClasses/MapObject.dart';
import 'MapClasses/ZoomContainer.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';



//This class initializes the map that we provide as a .png image
//it as well, sets a MapObject of color red, at a preset offset and of our desired
//size to be placed on the image
class CampusMap extends StatelessWidget {
  double lat;
  double long;
  CampusMap({
    super.key,
    this.lat=51.3410250,
    this.long=12.3784733,
  });

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
              offset: const Offset(0, 0),
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
