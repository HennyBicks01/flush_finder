import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'settings.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _scale = 2.5;
  double? _minScale;
  double? _imageWidth;
  double? _imageHeight;
  ui.Image? _image;  // To hold the raw image data

  bool _showSettings = false;

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
  }

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
      _image = imageInfo.image;
      _imageWidth = _image!.width.toDouble();
      _imageHeight = _image!.height.toDouble();

      // Adjusted _minScale calculation
      double widthRatio = MediaQuery.of(context).size.width / _imageWidth!;
      double heightRatio = MediaQuery.of(context).size.height / _imageHeight!;
      _minScale = widthRatio > heightRatio ? widthRatio : heightRatio;

      _scale = _minScale!;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchImageDimensions();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageWidth == null || _imageHeight == null || _image == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          PhotoView.customChild(
            initialScale: _minScale!,
            basePosition: Alignment.topCenter,
            childSize: Size(_imageWidth!, _imageHeight!),
            minScale: _minScale!,
            maxScale: 4.0,
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            heroAttributes: const PhotoViewHeroAttributes(tag: 'someTag'),
            child: CustomPaint(
              painter: FilteredImagePainter(_image!, _scale),
              size: Size(_imageWidth!, _imageHeight!),
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.red.withOpacity(0.2),
            ),
          ),
          Positioned(
            left: 10,  // Adjust this value for desired left offset
            top: 50,   // Adjust this value to lower or raise the button
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Handle menu button press
              },
            ),
          ),
          Positioned(
            right: 10,
            top: 50,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ),
            ]
          ),
        );
      }
    }
class FilteredImagePainter extends CustomPainter {
  final ui.Image image;
  final double scale;

  FilteredImagePainter(this.image, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(image.width.toDouble(), image.height.toDouble()),
      ),
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.width, size.height),
      ),
      Paint()
        ..colorFilter = const ColorFilter.mode(
          Colors.grey,
          BlendMode.saturation,
        ),
    );
    // Add the red overlay on top
    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.width, size.height),
      ),
      Paint()..color = Colors.red.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
