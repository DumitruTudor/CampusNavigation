import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'ImageViewport.dart';
import 'MapObject.dart';
import 'ZoomContainer.dart';

class ZoomContainerState extends State<ZoomContainer> {
  late double _zoomLevel;
  late ImageProvider _imageProvider;
  late List<MapObject> _objects;
  Offset offset = Offset(0, 0);
  Position? pos;
  //double lat = 51.3410600;
  double? long;
  bool hasArrived = false;
  Position? _currentPosition;

  double destinationLatitude = 51.34108507;
  double destinationLongitude = 12.3786695;

  double startingLatitude = 51.3409598;
  double startingLongitude = 12.3783115;
  // function that gets the current location using Geolocator API
  // set the location accuracy as accurate as possible for navigation purpose
  // print out the latitude and longitude with restricted (6) decimal numbers

  _getCurrentLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        _currentPosition = position;

        String? currentStringLatitude =
            _currentPosition?.latitude.toStringAsFixed(7);
        String? currentStringLongitude =
            _currentPosition?.longitude.toStringAsFixed(7);

        double currentLatitude = double.parse(currentStringLatitude!);
        double currentLongitude = double.parse(currentStringLongitude!);

        //Lat: 10877
        //Long: 86825
        //ElevatorLat 09598 -> -0.00000 Offset dx
        //ElevatorLong 83115 -> -0.00000 Offset dy

        double differenceLat = (currentLatitude - startingLatitude) / 0.0000001;
        double differenceLong =
            (currentLongitude - startingLongitude) / 0.0000001;
        double x = (-1) * differenceLat * (0.00027365);
        double y = (-1) * differenceLong * (0.00020216);
        _objects.first.offset = Offset(x, y);

        if (_currentPosition!.latitude <= destinationLatitude + 0.0000100 &&
                _currentPosition!.latitude >=
                    destinationLatitude - 0.0000100 //&&
            /* _currentPosition!.longitude <= destinationLongitude + 0.0000100 &&
            _currentPosition!.longitude >= destinationLongitude - 0.0000100 */
            ) {
          hasArrived = true;
          dispose();
        }
        print(
            "Lat: ${_currentPosition?.latitude},\nLong: ${_currentPosition?.longitude},\nOffsetDx:$x,\nOffsetDy:$y");
      });
    });
  }

  @override
  void dispose() {
    _getCurrentLocation().cancel();
    super.dispose();
  }

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

  void changeImage() {
    setState(() {
      _imageProvider = Image.asset("assets/map_directions.png").image;
    });
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
              icon: const Icon(Icons.zoom_in, color: Colors.red),
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
              icon: const Icon(
                Icons.zoom_out,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  _zoomLevel = _zoomLevel / 2;
                });
              },
            ),
            MaterialButton(
              onPressed: () {
                _getCurrentLocation();
                changeImage();
              },
              child: const Text("Get Current Location"),
            ),
          ],
        ),
      ],
    );
  }
}
