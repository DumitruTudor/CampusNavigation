import 'package:flutter/material.dart';
import 'MapObject.dart';
import 'ImageViewportState.dart';

//This class handles the Image provided for our map
class ImageViewport extends StatefulWidget {
  final double zoomLevel;
  final ImageProvider imageProvider;
  final List<MapObject> objects;

  const ImageViewport({
    super.key,
    required this.zoomLevel,
    required this.imageProvider,
    required this.objects,
  });

  @override
  State<StatefulWidget> createState() => ImageViewportState();
}
