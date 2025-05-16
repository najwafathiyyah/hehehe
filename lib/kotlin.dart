import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'homepage.dart';

class GPSService {
  static const EventChannel _streamChannel =
      EventChannel('com.example.app/gps_stream');

  Stream<Map<String, double>> getLocationStream() {
    return _streamChannel.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      return {
        'latitude': map['latitude'],
        'longitude': map['longitude'],
      };
    });
  }
}

class GPSPage extends StatefulWidget {
  @override
  _GPSPageState createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    GPSService().getLocationStream().listen((location) {
      setState(() {
        _latitude = location['latitude'];
        _longitude = location['longitude'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Realtime GPS Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_latitude != null && _longitude != null)
              Text(
                'Lat: $_latitude, Lon: $_longitude',
                style: TextStyle(fontSize: 18),
              )
            else
              Text('Menunggu lokasi...', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            if (_latitude != null && _longitude != null)
              Container(
                height: 300,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(_latitude!, _longitude!),
                    zoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_latitude!, _longitude!),
                          width: 40,
                          height: 40,
                          builder: (context) => const Icon(
                            Icons.location_pin,
                            color: Colors.green,
                            size: 20,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
