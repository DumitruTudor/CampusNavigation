import 'dart:ui';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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

//This class handles everything that happens to the image on the screen
class _ImageViewportState extends State<ImageViewport> {
  late double _zoomLevel;
  late ImageProvider _imageProvider;
  late ui.Image _image;
  late bool _resolved;
  late Offset _centerOffset;
  late double _maxHorizontalDelta;
  late double _maxVerticalDelta;
  late Offset _normalized;
  bool _denormalize = false;
  late Size _actualImageSize;
  late Size _viewportSize;

  late List<MapObject> _objects;

  double abs(double value) {
    return value < 0 ? value * (-1) : value;
  }

  //first render of the image at the appropriate size
  void _updateActualImageDimensions() {
    _actualImageSize = Size(
        (_image.width / window.devicePixelRatio) * _zoomLevel,
        (_image.height / ui.window.devicePixelRatio) * _zoomLevel);
  }

  //Initializing all the variables
  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.zoomLevel;
    _imageProvider = widget.imageProvider;
    _resolved = false;
    _centerOffset = const Offset(0, 0);
    _objects = widget.objects;
  }

  //Gives an image provider to the screen
  void _resolveImageProvider() {
    ImageStream stream =
        _imageProvider.resolve(createLocalImageConfiguration(context));
    stream.addListener(ImageStreamListener(
      (info, _) async {
        _image = info.image;
        _resolved = true;
        _updateActualImageDimensions();
        setState(() {});
      },
    ));
  }

  //Checking for dependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImageProvider();
  }

  //Checking if the image dimensions have changed and alter it accordingly
  @override
  void didUpdateWidget(ImageViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != _imageProvider) {
      _imageProvider = widget.imageProvider;
      _resolveImageProvider();
    }
    double normalizedDx =
        _maxHorizontalDelta == 0 ? 0 : _centerOffset.dx / _maxHorizontalDelta;
    double normalizedDy =
        _maxVerticalDelta == 0 ? 0 : _centerOffset.dy / _maxVerticalDelta;
    _normalized = Offset(normalizedDx, normalizedDy);
    _denormalize = true;
    _zoomLevel = widget.zoomLevel;
    _updateActualImageDimensions();
  }

  //This method converts map objects from the map centre to the local viewport
  //offset from the top left viewport corner
  Offset _globaltoLocalOffset(Offset value) {
    double hDelta = (_actualImageSize.width / 2) * value.dx;
    double vDelta = (_actualImageSize.height / 2) * value.dy;
    double dx = (hDelta - _centerOffset.dx) + (_viewportSize.width / 2);
    double dy = (vDelta - _centerOffset.dy) + (_viewportSize.height / 2);
    return Offset(dx, dy);
  }

  //In this method we take an offset value and we use it for a long-press event
  //to convert it's local coordinates to relative offsets from the map centre
  Offset _localToGlobalOffset(Offset value) {
    double dx = value.dx - _viewportSize.width / 2;
    double dy = value.dy - _viewportSize.height / 2;
    double dh = dx + _centerOffset.dx;
    double dv = dy + _centerOffset.dy;
    return Offset(
      dh / (_actualImageSize.width / 2),
      dv / (_actualImageSize.height / 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    //This method handles panning around the screen
    void handleDrag(DragUpdateDetails updateDetails) {
      Offset newOffset = _centerOffset.translate(
          -updateDetails.delta.dx, -updateDetails.delta.dy);
      if (abs(newOffset.dx) <= _maxHorizontalDelta &&
          abs(newOffset.dy) <= _maxVerticalDelta) {
        setState(() {
          _centerOffset = newOffset;
        });
      }
    }

    //This method adds a map object to the image
    void addMapObject(MapObject object) => setState(() {
          _objects.add(object);
        });
    //This  method removes a map object from the image
    void removeMapObject(MapObject object) => setState(() {
          _objects.remove(object);
        });
    //This widget allows us to remove a placed map object by the user
    //Only an experimental feature that might represent a pin system in the future
    List<Widget> buildObjects() {
      return _objects
          .map(
            (MapObject object) => Positioned(
              left: _globaltoLocalOffset(object.offset).dx -
                  ((object.size.width * _zoomLevel) / 2),
              top: _globaltoLocalOffset(object.offset).dy -
                  ((object.size.height * _zoomLevel) / 2),
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  late MapObject info;
                  info = MapObject(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                      )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text("Close me"),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => removeMapObject(info),
                          ),
                        ],
                      ),
                    ),
                    offset: object.offset,
                    size: Size.zero,
                  );
                  addMapObject(info);
                },
                child: SizedBox(
                  width: object.size.width * _zoomLevel,
                  height: object.size.height * _zoomLevel,
                  child: object.child,
                ),
              ),
            ),
          )
          .toList();
    }

    //build the screen layout for the image
    return _resolved
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _viewportSize = Size(
                  min(constraints.maxWidth, _actualImageSize.width),
                  min(constraints.maxHeight, _actualImageSize.height));
              _maxHorizontalDelta =
                  (_actualImageSize.width - _viewportSize.width) / 2;
              _maxVerticalDelta =
                  (_actualImageSize.height - _viewportSize.height) / 2;
              bool reactOnHorizontalDrag =
                  _maxHorizontalDelta > _maxVerticalDelta;
              bool reactOnPan =
                  (_maxHorizontalDelta > 0 && _maxVerticalDelta > 0);
              if (_denormalize) {
                _centerOffset = Offset(_maxHorizontalDelta * _normalized.dx,
                    _maxVerticalDelta * _normalized.dy);
                _denormalize = false;
              }
              //This handles the gesture of panning around the screen
              return GestureDetector(
                onPanUpdate: reactOnPan ? handleDrag : null,
                onHorizontalDragUpdate:
                    reactOnHorizontalDrag && !reactOnPan ? handleDrag : null,
                onVerticalDragUpdate:
                    !reactOnHorizontalDrag && !reactOnPan ? handleDrag : null,
                onLongPressEnd: (LongPressEndDetails details) {
                  RenderBox? box = context.findRenderObject() as RenderBox?;
                  Offset? localPosition =
                      box?.globalToLocal(details.globalPosition);
                  Offset newObjectOffset = _localToGlobalOffset(localPosition!);
                  MapObject newObject = MapObject(
                    child: Container(
                      color: Colors.grey, //mapObject color
                    ),
                    offset: newObjectOffset,
                    size: const Size(10, 10),
                  );
                  addMapObject(newObject);
                },
                child: Stack(
                  children: <Widget>[
                        CustomPaint(
                          size: _viewportSize,
                          painter:
                              MapPainter(_image, _zoomLevel, _centerOffset),
                        ),
                      ] +
                      buildObjects(),
                ),
              );
            },
          )
        : const SizedBox();
  }
}

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
  State<StatefulWidget> createState() => _ImageViewportState();
}

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

class ZoomContainerState extends State<ZoomContainer> {
  late double _zoomLevel;
  late ImageProvider _imageProvider;
  late List<MapObject> _objects;

  //Initializing zoom level, image provider and widget object
  @override
  void initState() {
    super.initState();
    _zoomLevel = widget.zoomLevel;
    _imageProvider = widget.imageProvider;
    _objects = widget.objects;
  }

  //Checks if the widgdet got updated and if it did, then it replaces our
  //image provider with the new one
  @override
  void didUpdateWidget(ZoomContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != _imageProvider) {
      _imageProvider = widget.imageProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ImageViewport(
          zoomLevel: _zoomLevel,
          imageProvider: _imageProvider,
          objects: _objects,
        ),
        Row(
          children: <Widget>[
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.zoom_in),
              onPressed: () {
                setState(() {
                  _zoomLevel = _zoomLevel * 2;
                });
              },
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.zoom_out),
              onPressed: () {
                setState(() {
                  _zoomLevel = _zoomLevel / 2;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

//The ZoomContainer provides the class with variables such as:
//zoomLevel, imageProvider, list of object of type <MapObject
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
          zoomLevel: 0.2,
          imageProvider: Image.asset("assets/map.png").image,
          objects: [
            MapObject(
              child: Container(
                color: Colors.red,
              ),
              offset: const Offset(-0.21, 0.31),
              size: const Size(60, 60),
            ),
          ],
        ),
      ),
    );
  }
}
