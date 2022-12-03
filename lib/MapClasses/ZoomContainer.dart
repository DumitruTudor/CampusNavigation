//The ZoomContainer provides the class with variables such as:
//zoomLevel, imageProvider, list of object of type <MapObject>
import 'package:flutter/cupertino.dart';
import 'MapObject.dart';
import 'ZoomContainerState.dart';

class ZoomContainer extends StatefulWidget {
  final double zoomLevel;
  final ImageProvider imageProvider;
  final List<MapObject> objects;

  const ZoomContainer({
    super.key,
    this.zoomLevel = 1,
    required this.imageProvider,
    this.objects = const [],
  });

  @override
  State<StatefulWidget> createState() => ZoomContainerState();
}
