import 'package:flutter/material.dart';

class PicturePanZoomComponent extends StatefulWidget {
  const PicturePanZoomComponent({Key? key}) : super(key: key);

  @override
  _PicturePanZoomComponentState createState() =>
      _PicturePanZoomComponentState();
}

//This component helps with the state of the panning and zooming of the screen
//it handles mainly the buttons for zoom in/zoom out
class _PicturePanZoomComponentState extends State<PicturePanZoomComponent> {
  double top = 0;
  double left = 0;
  double ratio = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: GestureDetector(
            onPanUpdate: _handlePanUpdate,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: top,
                  left: left,
                  width: 660 * ratio,
                  child: Image.network(
                    "https://img.purch.com/w/660/aHR0cDovL3d3dy5saXZlc2NpZW5jZS5jb20vaW1hZ2VzL2kvMDAwLzEwNC84MTkvb3JpZ2luYWwvY3V0ZS1raXR0ZW4uanBn",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _handleZoomIn,
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _handleZoomOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //This method handles the update done to the screen while panning around
  //with a finger, where it takes the top and left positions and modifies them
  //by the delta coordinates of the "details" variable at the x and y coordinate
  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      top = top + details.delta.dy;
      left = left + details.delta.dx;
    });
  }

  //This method handles the ratio at which the button for zooming, zooms the
  //screen
  void _handleZoomIn() {
    setState(() {
      ratio *= 1.5;
    });
  }

  //This method handles the ratio at which the zoom out button, zooms out
  void _handleZoomOut() {
    setState(() {
      ratio /= 1.5;
    });
  }
}

void main() => runApp(const MyApp());

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simpler approach"),
      ),
      body: const Center(
        child: PicturePanZoomComponent(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
