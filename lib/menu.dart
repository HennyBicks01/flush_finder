import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7, // 70% of screen width
      color: Colors.blueGrey[800], // Dark shade of grey (can be changed)
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle tap on Home
                },
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.white),
                title: const Text('Favorites', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle tap on Favorites
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Handle tap on Settings
                },
              ),
              // Add more ListTiles as needed...
            ],
          ),
        ),
      ),
    );
  }
}
