import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'ImageViewport.dart';
import 'MapObject.dart';
import 'ZoomContainer.dart';

class ZoomContainerState extends State<ZoomContainer> {
  // creating variable for saving location coordinates
  late double _zoomLevel;
  late ImageProvider _imageProvider;
  late List<MapObject> _objects;
  Offset offset = Offset(0, 0);
  Position? pos;
  //double lat = 51.3410600;
  double? long;
  bool hasArrived = false;
  Position? _currentPosition;

  double destinationLatitude = 51.3410507;
  double destinationLongitude = 12.3786695;

  double startingLatitude = 51.3409598;
  double startingLongitude = 12.3783115;

  // function that gets the current location using Geolocator API
  // set the location accuracy as accurate as possible for navigation purpose
  // print out the latitude and longitude with restricted (6) decimal numbers

  getCurrentLocation() async {
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
        double y = (-1) * differenceLong * (0.00019800);
/*         if ((y < 0.14 && y > -0.52 && x > -0.04 && x < 0.04) ||
            (y < -0.52 && y > -0.6 && x > -0.33 && x < 0.34) ||
            (y < -0.38 && y > -0.73 && x > -0.41 && x < 0.33)) {
          _objects.first.offset = Offset(x, y);
        } */
        _objects.first.offset = Offset(x, y);

        if (_currentPosition!.latitude <= destinationLatitude + 0.0000100 &&
                _currentPosition!.latitude >=
                    destinationLatitude - 0.0000100 //&&
            /* _currentPosition!.longitude <= destinationLongitude + 0.0000100 &&
            _currentPosition!.longitude >= destinationLongitude - 0.0000100 */
            ) {
          hasArrived = true;
        }
        print(hasArrived);
        print(
            "Lat: ${_currentPosition?.latitude},\nLong: ${_currentPosition?.longitude},\nOffsetDx:$x,\nOffsetDy:$y");
      });
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    //Test if the location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error("Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //Permisions are denied forever, handle appropriately
      return Future.error(
          "Location permissions are permanently denied, we cannot request permissions.");
    }
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
            Container(
              child: widget.mapOrLocation
                  ? MaterialButton(
                      onPressed: () {
                        getCurrentLocation();
                        changeImage();
                      },
                      child: const Text("Get Current Location"),
                      color: Colors.lightBlue,
                    )
                  : Text("Campus Map"),
            )
          ],
        ),
        if (hasArrived)
          const AlertDialog(
              title: Text("You have arrived"),
              content: Text("You have arrived"))
      ],
    );
  }
}
