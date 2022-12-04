import 'package:flutter/material.dart';
import 'locationCoordinate.dart';
import 'map.dart';

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
              Text("Welcome"),
              //const SizedBox(height: 360),
              ElevatedButton(
                key: navigateToMapButtonKey,
                /*style:
                    ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue ),
                      fixedSize: MaterialStateProperty.all<Size>(
                          const Size(350,60)
                      ),
                    ),*/
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Campus()));
                },
                child: const Text(
                  "Map",
                ),
              ),
              //const SizedBox(height: 20),
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
}
