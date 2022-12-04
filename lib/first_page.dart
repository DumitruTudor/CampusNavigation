import 'package:flutter/material.dart';
import 'location_page.dart';
import 'map_page.dart';

//creating the first page/site for the ease of demonstrating the campus map and the location service we have created
//the first page navigates the user between the different sites of our app
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const navigateToMapButtonKey = Key('navigateToMap');
  static const navigateToLocationButtonKey = Key('navigateToLocation');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: Align(
          alignment: Alignment.center,
              child: Column(
              children: <Widget>[
                const SizedBox(height: 290),
                ElevatedButton(
                  key: navigateToMapButtonKey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CampusMap()));
                  },
                  child: const Text(
                    "Map",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: navigateToLocationButtonKey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LocationApp()));
                  },
                  child: const Text(
                    "Location",
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
