import 'package:flutter/material.dart';
import 'package:flutter_application_1/design.dart';
import 'firstpage.dart';
import 'map.dart';
import 'locationCoordinate.dart';

void main() {
  runApp(LUCampusNavigation());
}

class LUCampusNavigation extends StatelessWidget {
  const LUCampusNavigation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      initialRoute: 'firstpage',
      routes: {
        'firstpage': (context) => HomePage(),
        '/map': (context) => CampusMap(),
        '/location': (context) => LocationApp(),
      },
    );
  }
}
