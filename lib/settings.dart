import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _switchValue1 = false;
  bool _switchValue2 = false;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Test Switch 1', style: TextStyle(color: Colors.white)),
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
              const Text('Test Switch 2', style: TextStyle(color: Colors.white)),
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
              const Text('Test Slider', style: TextStyle(color: Colors.white)),
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
    );
  }
}
