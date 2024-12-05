import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;
//import 'package:flutter_map/src/layer/polygon_layer/polygon_layer.dart' as fm;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SaiPage(), // Halaman pertama yang akan ditampilkan
    );
  }
}

class SaiPage extends StatelessWidget {
  const SaiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center:
              latlong2.LatLng(21.422270, 39.826426), // Gunakan latlong2.LatLng
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
                  latlong2.LatLng(21.42499, 39.826689), // Sudut 1
                  latlong2.LatLng(21.425068, 39.827437),
                ],
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
              Polygon(
                points: [
                  latlong2.LatLng(21.422078, 39.827637),
                  latlong2.LatLng(21.422023, 39.827128),
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
