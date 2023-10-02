import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Google Maps Integration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng? _currentPosition;
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationListener();
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locData = await location.getLocation();
    setState(() {
      _currentPosition = LatLng(locData.latitude!, locData.longitude!);
    });
  }

  _startLocationListener() {
    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("current_position"),
                position: _currentPosition!,
              ),
            },
          ),
          Container(
            color: Colors.red.withOpacity(0.7), // More opaque
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 1', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 2', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 3', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 4', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 5', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

}

