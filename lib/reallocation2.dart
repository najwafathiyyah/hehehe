import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;
//import 'package:flutter_map/src/layer/polygon_layer/polygon_layer.dart' as fm;
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Reallocation2(), // Halaman pertama yang akan ditampilkan
    );
  }
}

class Reallocation2 extends StatelessWidget {
  const Reallocation2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 246),
      appBar: AppBar(
        title: Text('Dummy Sa\'i'),
        titleTextStyle: TextStyle(fontSize: 18),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          center:
              latlong2.LatLng(-7.276007, 112.793186), // Gunakan latlong2.LatLng
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  latlong2.LatLng(-7.276007, 112.793186), // Sudut 1
                  latlong2.LatLng(-7.276178, 112.793165),
                ],
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
              Polygon(
                points: [
                  latlong2.LatLng(-7.276152, 112.794468),
                  latlong2.LatLng(-7.276067, 112.794472),
                ],
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
