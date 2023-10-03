import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  final VoidCallback toggleSettings;

  const SettingsWidget({required this.toggleSettings, Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool _switchValue1 = false;
  bool _switchValue2 = false;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Test Switch 1'),
                Switch(
                  value: _switchValue1,
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
                Text('Test Switch 2'),
                Switch(
                  value: _switchValue2,
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
                Text('Test Slider'),
                Expanded(
                  child: Slider(
                    value: _sliderValue,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ], // This was the problematic comma
        ),
      ),
    );
  }
}