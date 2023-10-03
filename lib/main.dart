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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _scale = 2.5;
  double _xOffset = 0.0;
  double _yOffset = 0.0;

  final double imageWidth = 1053.0;  // Original image width
  final double imageHeight = 951.0;  // Original image height

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.delta.dx;
      _yOffset += details.delta.dy;

      var screenSize = MediaQuery.of(context).size;
      var scaledImageWidth = imageWidth * _scale;
      var scaledImageHeight = imageHeight * _scale;

      // Calculate the boundary offsets
      double maxXOffset = (scaledImageWidth - screenSize.width) / 2;
      double maxYOffset = (scaledImageHeight - screenSize.height) / 2;

      // Clamp the offsets to ensure the image boundaries aren't crossed
      _xOffset = _xOffset.clamp(-maxXOffset, maxXOffset);
      _yOffset = _yOffset.clamp(-maxYOffset, maxYOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: _onPanUpdate,
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(_xOffset, _yOffset),
              child: Transform.scale(
                scale: _scale,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Image.asset(
                    'assets/uc_campus_map.png',
                    fit: BoxFit.cover,
                  ),
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
    );
  }
}
