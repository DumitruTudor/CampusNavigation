import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationApp extends StatefulWidget{
  const LocationApp({super.key});

  @override
    _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp>{
  // creating variable for saving location coordinates
  var locationMessage = "";

  // function that gets the current location using Geolocator API
  // set the location accuracy as accurate as possible for navigation purpose
  // print out the latitude and longitude with restricted (6) decimal numbers
  void getCurrentLocation()async{
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    var lat = double.parse(position.latitude.toStringAsFixed(6));
    var lon = double.parse(position.longitude.toStringAsFixed(6));
    setState(() {
      locationMessage="Your Position:\nLatitude: $lat,\nLongitude: $lon";
    });
  }

  // build the context for displaying the current coordinates
  // returning a visual scaffold for Material Design widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LocationApp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
                Icons.location_on,
                size:45,
                color:Colors.blue),
            const SizedBox(
              height:10.0,
            ),
            const Text(
              "Get user Location",
              style:TextStyle(fontSize: 26,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:20,),
            Text("$locationMessage\n", textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),
            ElevatedButton(
              onPressed: (){
                getCurrentLocation();
              },
              child: const Text("Get Current Location"),
            )
          ],
        ),
      ),
    );
  }
}