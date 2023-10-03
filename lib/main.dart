import 'dart:async';
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
  double _scale = 2;
  double? _minScale; // Minimum scale
  double? _imageWidth;
  double? _imageHeight;

  Future<void> _fetchImageDimensions() async {
    final Image image = Image.asset('assets/uc_campus_map.png');
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) {
          if (!completer.isCompleted) {
            completer.complete(info);
          }
        },
      ),
    );
    final ImageInfo imageInfo = await completer.future;

    setState(() {
      _imageWidth = imageInfo.image.width.toDouble();
      _imageHeight = imageInfo.image.height.toDouble();
      _minScale = MediaQuery
          .of(context)
          .size
          .height / _imageHeight!; // Calculate minimum scale
      _scale = _minScale!; // Set the initial scale to the minimum scale
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchImageDimensions();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageWidth == null || _imageHeight == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: _imageWidth! * _scale,
              height: (_imageHeight! - 100) * _scale,
              // Adjust height based on the clipped portion
              child: Stack(
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: (_imageHeight! - 100) / _imageHeight!,
                      // Calculate the height factor based on the clipped portion
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          'assets/uc_campus_map.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red.withOpacity(
                        0.5), // This creates a semi-opaque red overlay
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
