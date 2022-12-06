import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/map_page.dart';
import 'package:geolocator/geolocator.dart';
import 'MapClasses/ZoomContainerState.dart';
import 'MapClasses/MapObject.dart';
import 'MapClasses/ZoomContainer.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({super.key});

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus navigator map"),
      ),
      body: Center(
        child: ZoomContainer(
          mapOrLocation: true,
          key: const Key("zoomContainer"),
          zoomLevel: 1,
          imageProvider: Image.asset("assets/map.png").image,
          objects: [
            MapObject(
              child: Container(
                color: Colors.red,
              ),
              //offset: const Offset(-0.21, 0.31),
              offset: Offset(0,0),
              size: const Size(15, 15),
            ),
          ],
        ),
      ),
    );
  }
}
