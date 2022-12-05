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
  double lat = 51.3410600;
  double? long;
  bool hasArrived = false;
  Position? _currentPosition;
  // function that gets the current location using Geolocator API
  // set the location accuracy as accurate as possible for navigation purpose
  // print out the latitude and longitude with restricted (6) decimal numbers
  _getCurrentLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
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
        _objects.first.offset =
            Offset((currentLatitude) - 51, (currentLongitude) - 12);
        if (_currentPosition!.latitude <= lat + 0.0000100 &&
                _currentPosition!.latitude >= lat - 0.0000100
            /*&& _currentPosition!.longitude <= long + 0.0000100 &&
            _currentPosition!.longitude >= long - 0.0000100*/
            ) {
          hasArrived = true;
        }
        print(
            "Lat: ${_currentPosition?.latitude},\nLong: ${_currentPosition?.longitude}");
      });
    });
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
              },
              child: const Text("Get Current Location"),
            ),
          ],
        ),
      ],
    );
  }
}
