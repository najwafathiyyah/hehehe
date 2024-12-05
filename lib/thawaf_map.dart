import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'homepage.dart';

class ThawafMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thawaf Tracker")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(21.4225, 39.8262), // Lokasi Ka'bah
          zoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  LatLng(21.4225, 39.8262), // Sudut 1 (pusat ka'bah)
                  LatLng(21.421998, 39.827817), // Sudut 2 (hajar aswad)
                  LatLng(21.424048, 39.826513), // Sudut 3 (yamani)
                ],
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 2,
              ),
              Polygon(
                points: [
                  LatLng(21.4225, 39.8262), // Sudut 1 (pusat ka'bah)
                  LatLng(21.424048, 39.826513), // Sudut 2 (yamani)
                  LatLng(21.422894, 39.824397), // Sudut 3 (syami)
                ],
                color: Colors.red.withOpacity(0.3),
                borderColor: Colors.red,
                borderStrokeWidth: 2,
              ),
              Polygon(
                points: [
                  LatLng(21.4225, 39.8262), // Sudut 1 (pusat ka'bah)
                  LatLng(21.422894, 39.824397), // Sudut 2 (syami)
                  LatLng(21.420937, 39.825784), // Sudut 3 (iraqi)
                ],
                color: Colors.green.withOpacity(0.3),
                borderColor: Colors.green,
                borderStrokeWidth: 2,
              ),
              Polygon(
                points: [
                  LatLng(21.4225, 39.8262), // Sudut 1 (pusat ka'bah)
                  LatLng(21.420937, 39.825784), // Sudut 2 (iraqi)
                  LatLng(21.421998, 39.827817), // Sudut 3 (hajar aswad)
                ],
                color: Colors.purple.withOpacity(0.3),
                borderColor: Colors.purple,
                borderStrokeWidth: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
