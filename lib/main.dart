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
  double _scale = 1.0;
  double _xOffset = 0.0;
  double _yOffset = 0.0;

  void _zoomToMarker() {
    setState(() {
      _scale = 2.0;
      _xOffset = -100;  // Values adjusted to center the marker
      _yOffset = -150;  // Values adjusted to center the marker
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onDoubleTap: _zoomToMarker,
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
              left: 100, // Adjust these values to position the marker
              top: 150,  // Adjust these values to position the marker
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
