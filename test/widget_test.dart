// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_application_1/locationCoordinate.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Campus Navigation first page widget test', (WidgetTester tester) async {
    //find all the
    //final mapButton = find.byKey(ValueKey('navigateToMap'));
    //final locationButton = find.byKey(ValueKey('navigateToLocation'));

    // setup
    await tester.pumpWidget(const LocationApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    //do
    //final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final titleFinder = find.text("LocationApp");
    final textFinder = find.text("Get user Location");
    //test
    //expect(button.child,const Text('Map'));
    expect(titleFinder, findsOneWidget);
    expect(textFinder,findsOneWidget);
    //expect(find.byWidget(const CampusMap()),findsOneWidget);
  });
}
