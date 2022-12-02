import 'package:flutter/cupertino.dart';

class MapObject {
  final Widget child;

  //this offset is used to determine the position of a map object
  final Offset offset;

  //this determines the desired size of our map object
  final Size size;

  MapObject({
    required this.child,
    required this.offset,
    required this.size,
  });
}
