import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:ui';

//This class handles taking our image for the map and displaying it on a canvas
//of the phone screen, knowing to take into consideration the resolution
//of the screen
class MapPainter extends CustomPainter {
  final ui.Image image;
  final double zoomLevel;
  final Offset centerOffset;

  MapPainter(this.image, this.zoomLevel, this.centerOffset);

  @override
  void paint(Canvas canvas, Size size) {
    double pixelRatio = window.devicePixelRatio;
    Size sizeInDevicePixels =
        Size(size.width * pixelRatio, size.height * pixelRatio);
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    Offset centerOffsetInDevicePixels =
        centerOffset.scale(pixelRatio / zoomLevel, pixelRatio / zoomLevel);
    Offset centerInDevicePixels = Offset(image.width / 2, image.height / 2)
        .translate(
            centerOffsetInDevicePixels.dx, centerOffsetInDevicePixels.dy);
    Offset topLeft = centerInDevicePixels.translate(
        -sizeInDevicePixels.width / (2 * zoomLevel),
        -sizeInDevicePixels.height / (2 * zoomLevel));
    Offset rightBottom = centerInDevicePixels.translate(
        sizeInDevicePixels.width / (2 * zoomLevel),
        sizeInDevicePixels.height / (2 * zoomLevel));
    canvas.drawImageRect(
      image,
      Rect.fromPoints(topLeft, rightBottom),
      Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
