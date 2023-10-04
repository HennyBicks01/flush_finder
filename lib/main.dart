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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  double _scale = 2.5;
  double? _minScale;
  double? _imageWidth;
  double? _imageHeight;
  ui.Image? _image; // To hold the raw image data

  bool _showSettings = false;
  late AnimationController _animationController;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _settingsFadeAnimation;


  void _toggleSettings() {
    if (_showSettings) {
      _animationController.reverse(); // to play the animation in reverse
    } else {
      _animationController.forward(); // to play the animation forward
    }

    // After the animation is complete, toggle _showSettings
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showSettings = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _showSettings = false;
        });
      }
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
      double widthRatio = MediaQuery
          .of(context)
          .size
          .width / _imageWidth!;
      double heightRatio = MediaQuery
          .of(context)
          .size
          .height / _imageHeight!;
      _minScale = widthRatio > heightRatio ? widthRatio : heightRatio;

      _scale = _minScale!;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchImageDimensions();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Set up the animations
    _blurAnimation = Tween<double>(begin: 3.0, end: 10.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    _opacityAnimation = Tween<double>(begin: 0.2, end: 0.25).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    _settingsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
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
            backgroundDecoration: const BoxDecoration(
                color: Colors.transparent),
            heroAttributes: const PhotoViewHeroAttributes(tag: 'someTag'),
            child: CustomPaint(
              painter: FilteredImagePainter(_image!, _scale),
              size: Size(_imageWidth!, _imageHeight!),
            ),
          ),
          // Backdrop blur.
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return BackdropFilter(
                filter: ui.ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: Colors.red.withOpacity(_opacityAnimation.value),
                ),
              );
            },
          ),
          // Settings fade-in/fade-out.
          FadeTransition(
            opacity: _settingsFadeAnimation,
            child: SettingsWidget(),
          ),
          Positioned(
            left: 10, // Adjust this value for desired left offset
            top: 50, // Adjust this value to lower or raise the button
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
              onPressed: _toggleSettings, // Toggle settings without navigation
            ),
          ),

          // Only render the column with buttons when _showSettings is false
          if (!_showSettings)
          // Render the column with buttons when _showSettings is false
            FadeTransition(
              // Inverse the opacity for the opposite effect
              opacity: _settingsFadeAnimation.drive(Tween<double>(begin: 1.0, end: 0.0)),
              child: Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press for Button 1
                        },
                        child: Text("Button 1"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press for Button 2
                        },
                        child: Text("Button 2"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
