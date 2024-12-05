import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class DummyThawafPage extends StatefulWidget {
  @override
  _DummyThawafPageState createState() => _DummyThawafPageState();
}

class _DummyThawafPageState extends State<DummyThawafPage> {
  List<LatLng> trackPoints = [];
  bool isTracking = false;
  StreamSubscription<Position>? positionStream;
  int lapCount = 0;
  bool isNearStartPoint = false;
  LatLng? startPoint;
  LatLng? currentPosition;
  static const double threshold = 0.00005; // Sekitar 5 meter dalam koordinat
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    trackPoints = [];
    isTracking = false;
    lapCount = 0;
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      startPoint = currentPosition;
    });
  }

  bool _isNearPoint(LatLng point1, LatLng point2) {
    return (point1.latitude - point2.latitude).abs() < threshold &&
        (point1.longitude - point2.longitude).abs() < threshold;
  }

  void _checkLapCompletion(LatLng position) {
    if (startPoint != null && _isNearPoint(position, startPoint!)) {
      if (!isNearStartPoint && trackPoints.length > 20) {
        setState(() {
          lapCount++;
        });
        isNearStartPoint = true;
      }
    } else {
      isNearStartPoint = false;
    }
  }

  void startTracking() async {
    if (startPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waiting for GPS location...')));
      return;
    }

    setState(() {
      isTracking = true;
      trackPoints.clear();
      lapCount = 0;
      isNearStartPoint = false;
    });

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        currentPosition = newPosition;
        if (isTracking) {
          trackPoints.add(newPosition);
          _checkLapCompletion(newPosition);
        }
        mapController.move(newPosition, mapController.zoom);
      });
    });
  }

  void stopTracking() {
    setState(() {
      isTracking = false;
    });
    positionStream?.cancel();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thawaf Tracker")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentPosition ??
                  LatLng(-7.276590, 112.793885), // Pusat Ka'bah
              zoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                //ignoreLocationMarker: true,
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885), // Sudut 1 (pusat ka'bah)
                      LatLng(-7.276586, 112.793757), // Sudut 2 (hajar aswad)
                      LatLng(-7.276718, 112.793885), // Sudut 3 (yamani)
                    ],
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                  ),
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885), // Sudut 1 (pusat ka'bah)
                      LatLng(-7.276718, 112.793885), // Sudut 2 (yamani)
                      LatLng(-7.276594, 112.794026), // Sudut 3 (syami)
                    ],
                    color: Colors.red.withOpacity(0.3),
                    borderColor: Colors.red,
                    borderStrokeWidth: 2,
                  ),
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885), // Sudut 1 (pusat ka'bah)
                      LatLng(-7.276594, 112.794026), // Sudut 2 (syami)
                      LatLng(-7.276458, 112.793892), // Sudut 3 (iraqi)
                    ],
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.green,
                    borderStrokeWidth: 2,
                  ),
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885), // Sudut 1 (pusat ka'bah)
                      LatLng(-7.276458, 112.793892), // Sudut 2 (iraqi)
                      LatLng(-7.276586, 112.793757), // Sudut 3 (hajar aswad)
                    ],
                    color: Colors.purple.withOpacity(0.3),
                    borderColor: Colors.purple,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  if (isTracking)
                    Polyline(
                      points: trackPoints,
                      color: Colors.red,
                      strokeWidth: 3.0,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (currentPosition != null)
                    Marker(
                      point: currentPosition!,
                      width: 30,
                      height: 30,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  if (startPoint != null)
                    Marker(
                      point: startPoint!,
                      width: 30,
                      height: 30,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.start,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Putaran: $lapCount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    if (isTracking) {
                      stopTracking();
                    } else {
                      startTracking();
                    }
                  },
                  child: Icon(isTracking ? Icons.stop : Icons.play_arrow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
