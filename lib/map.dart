import 'package:flutter/material.dart';
import 'MapClasses/MapObject.dart';
import 'MapClasses/ZoomContainer.dart';

void main() {
  runApp(CampusMap());
}

//This class initializes the map that we provide as a .png image
//it as well, sets a MapObject of color red, at a preset offset and of our desired
//size to be placed on the image
class CampusMap extends StatelessWidget {
  const CampusMap({Key? key}) : super(key: key);

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
              offset: const Offset(-0.21, 0.31),
              size: const Size(15, 15),
            ),
          ],
        ),
      ),
    );
  }
}
