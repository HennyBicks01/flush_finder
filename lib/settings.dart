import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> with SingleTickerProviderStateMixin {
  bool _switchValue1 = false;
  bool _switchValue2 = false;
  double _sliderValue = 0.5;

  late AnimationController _controller;
  late Animation<double> _settingsOpacity;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _settingsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _blurAnimation = Tween<double>(begin: 3.0, end: 4.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Container(
                color: Colors.red.withOpacity(0.25),
              ),
            ),
            FadeTransition(
              opacity: _settingsOpacity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Test Switch 1', style: TextStyle(color: Colors.white)),
                        Switch(
                          value: _switchValue1,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              _switchValue1 = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Test Switch 2', style: TextStyle(color: Colors.white)),
                        Switch(
                          value: _switchValue2,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              _switchValue2 = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Test Slider', style: TextStyle(color: Colors.white)),
                        Expanded(
                          child: Slider(
                            value: _sliderValue,
                            activeColor: Colors.red,
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
