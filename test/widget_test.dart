// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_application_1/MapClasses/MapObject.dart';
import 'package:flutter_application_1/MapClasses/ZoomContainer.dart';
import 'package:flutter_application_1/location_page.dart';
import 'package:flutter_application_1/map_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Location page widget test', (WidgetTester tester) async {
    // setup
    await tester.pumpWidget(const MaterialApp(
      home:LocationApp()
    ) );
    await tester.pumpAndSettle(const Duration(seconds: 3));
    //do
    final titleFinder = find.text("LocationApp");
    final textFinder = find.text("Get user Location");
    final currentButton = find.byKey(const ValueKey('getCurrent'));
    final liveButton = find.byKey(const ValueKey('getLive'));
    //test
    expect(titleFinder, findsOneWidget);
    expect(textFinder,findsOneWidget);
    expect(currentButton, findsOneWidget);
    expect(liveButton, findsOneWidget);
  });
  testWidgets('Map page widget test', (WidgetTester tester) async {
    // setup
    Widget zoomContainer = ZoomContainer(imageProvider:Image.asset("assets/map.png").image );
    await tester.pumpWidget( MaterialApp(
        home:CampusMap()
    ) );
    await tester.pumpAndSettle(const Duration(seconds: 3));
    //do
    final titleFinder = find.text("Campus navigator map");
    final zoomInIcon = find.byIcon(Icons.zoom_in);
    final zoomOutIcon = find.byIcon(Icons.zoom_out);

    final finder = find.byKey(const ValueKey("zoomContainer"));
    final widget = tester.firstWidget(finder) as ZoomContainer;
    final zoomLevelFinder = widget.zoomLevel;
    final imageFinder = widget.imageProvider;
    final mapObjectFinder = widget.objects.first;

    //test
    expect(titleFinder, findsOneWidget);
    expect(zoomInIcon,findsOneWidget);
    expect(zoomOutIcon, findsOneWidget);
    expect(zoomLevelFinder, 1);
    expect(imageFinder, Image.asset("assets/map.png").image);
    expect(mapObjectFinder.offset,const Offset(0, 0) );
    expect(mapObjectFinder.size,const Size(15, 15) );
  });
}
