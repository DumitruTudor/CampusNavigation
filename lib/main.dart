import 'package:flutter/material.dart';
import 'package:flutter_application_1/Design/design.dart';
import 'first_page.dart';
import 'map_page.dart';
import 'location_page.dart';

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
