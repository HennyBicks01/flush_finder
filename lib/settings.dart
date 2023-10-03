import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SettingsPanel extends StatefulWidget {
  final bool showSettings;
  final VoidCallback toggleSettings;

  const SettingsPanel({super.key, required this.showSettings, required this.toggleSettings});

  @override
  SettingsPanelState createState() => SettingsPanelState();
}

class SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Increase blur when settings are shown
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: widget.showSettings ? 10.0 : 5.0,
            sigmaY: widget.showSettings ? 10.0 : 5.0,
          ),
          child: Container(
            color: Colors.red.withOpacity(0.5),
          ),
        ),

        // Settings Panel
        if (widget.showSettings)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,  // Adjust height based on your needs
              color: Colors.white,
              child: const Center(
                child: Text('Settings Panel'),
              ),
            ),
          ),

        // Settings Button
        Positioned(
          right: 10,
          top: 50,
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: widget.toggleSettings,
          ),
        ),
      ],
    );
  }
}
