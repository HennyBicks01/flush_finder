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

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _xOffset += details.delta.dx;
      _yOffset += details.delta.dy;

      var screenSize = MediaQuery.of(context).size;
      var scaledImageWidth = screenSize.width * _scale;
      var scaledImageHeight = screenSize.height * _scale;

      // Calculate overflow for each axis
      double overflowX = scaledImageWidth - screenSize.width;
      double overflowY = scaledImageHeight - screenSize.height;

      // If the image is smaller than the screen in that dimension, center it
      if (overflowX < 0) _xOffset = 0;
      if (overflowY < 0) _yOffset = 0;

      // If there's an overflow, clamp the offsets to half the overflow
      _xOffset = _xOffset.clamp(-overflowX / 2, overflowX / 2);
      _yOffset = _yOffset.clamp(-overflowY / 2, overflowY / 2);
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
