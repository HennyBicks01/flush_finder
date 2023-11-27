import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'polygon.dart';
import 'blueprint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flush Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Map Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController mapController = MapController();
  double zoom = 17.0; // Initial zoom level


  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    // ... Geolocation code (same as before)
  }

  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1; // Initialize j here
    bool isInside = false;
    for (i = 0; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > point.latitude) != (polygon[j].latitude > point.latitude)) &&
          (point.longitude < (polygon[j].longitude - polygon[i].longitude) * (point.latitude - polygon[i].latitude) / (polygon[j].latitude - polygon[i].latitude) + polygon[i].longitude)) {
        isInside = !isInside;
      }
    }
    return isInside;
  }

  LatLng calculateCentroid(List<LatLng> points) {
    double latitudeSum = 0.0;
    double longitudeSum = 0.0;
    for (var point in points) {
      latitudeSum += point.latitude;
      longitudeSum += point.longitude;
    }
    return LatLng(latitudeSum / points.length, longitudeSum / points.length);
  }

  List<Marker> createMarkersForPolygons(List<PolygonData> polygons) {
    return polygons.map((polygonData) {
      LatLng centroid = calculateCentroid(polygonData.polygon.points);
      return Marker(
        width: 100.0,
        height: 35.0,
        point: centroid,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            polygonData.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 0,
            ),
          ),
        ),
      );
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: const LatLng(39.1317, -84.5167), // Example coordinates
              zoom: zoom,
                onTap: (tapPosition, point) {
                  for (var polyData in getPolygons()) {
                    if (isPointInPolygon(point, polyData.polygon.points)) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Blueprint(buildingName: polyData.name),
                      ));
                      break;
                  }
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate : 'http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains  : ['a','b','c','d','e'],// Enable retina mode based on device density
                userAgentPackageName: 'com.example.app',
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Container(
                    color: const Color.fromRGBO(230 ,241 , 255, 1), // Blue
                  ),
                ),
              ),
              PolygonLayer(
                polygons: getPolygons().map((polyData) => polyData.polygon).toList(),
              ),
              MarkerLayer(
                markers: createMarkersForPolygons(getPolygons()),
              ),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF2D2D2D)),
              onPressed: () {
                // Handle settings action
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 60,
            right: 60,
            child: Material(
              borderRadius: BorderRadius.circular(30), // Set borderRadius here
              elevation: 2, // Optional: adds a slight shadow
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Same borderRadius as Material
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onSubmitted: (value) {
                  // Handle search
                },
              ),
            ),
          ),


          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF2D2D2D)),
              onPressed: () {
                // Handle menu action
              },
            ),
          ),
        ],
      ),
    );
  }
}
