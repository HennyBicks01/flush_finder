import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _scale = 2.5; // Increased initial zoom
  double _xOffset = 0.0; // Adjust these values for initial position
  double _yOffset = 0.0;

  void _zoomToMarker() {
    setState(() {
      _scale = 2.0;
      _xOffset = -100;
      _yOffset = -150;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.delta.dx;
      _yOffset += details.delta.dy;

      var screenSize = MediaQuery.of(context).size;

      // Calculate the boundary offsets
      double maxXOffset = (screenSize.width / 2) * (_scale - 1);
      double maxYOffset = (screenSize.height / 2) * (_scale - 1);

      // Clamp the offsets to ensure the image boundaries aren't crossed
      _xOffset = _xOffset.clamp(-maxXOffset, maxXOffset);
      _yOffset = _yOffset.clamp(-maxYOffset, maxYOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onDoubleTap: _zoomToMarker,
        onPanUpdate: _onPanUpdate,
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(_xOffset, _yOffset),
              child: Transform.scale(
                scale: _scale,
                child: Image.asset(
                  'assets/uc_campus_map.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Positioned(
              left: 100,
              top: 150,
              child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _zoomToMarker,
        tooltip: 'Zoom to Marker',
        child: const Icon(Icons.zoom_in),
      ),
    );
  }
}
