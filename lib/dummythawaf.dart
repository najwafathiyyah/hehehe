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
  LatLng? startPoint;
  LatLng? currentPosition;
  static const double threshold = 0.00005; // Sekitar 5 meter dalam koordinat
  final MapController mapController = MapController();

  int currentQuadrant = 0;
  List<int> quadrantSequence = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      if (startPoint == null) {
        startPoint = currentPosition;
      }
    });
  }

  void startTracking() {
    if (startPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waiting for GPS location...')));
      return;
    }

    setState(() {
      isTracking = true;
      trackPoints.clear();
      lapCount = 0;
      quadrantSequence.clear();
      currentQuadrant = 0;
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

  int _determineQuadrant(LatLng position) {
    // Logika menentukan kuadran berdasarkan posisi
    if (_isPointInPolygon(position, [
      LatLng(-7.276590, 112.793885), //sudut
      LatLng(-7.27659, 112.79207175340067), //barat
      LatLng(-7.278388643211837, 112.793885), //selatan
    ])) {
      return 1;
    } else if (_isPointInPolygon(position, [
      LatLng(-7.276590, 112.793885), //sudut
      LatLng(-7.278388643211837, 112.793885), //selatan
      LatLng(-7.27659, 112.7956982465994), //timur
    ])) {
      return 2;
    } else if (_isPointInPolygon(position, [
      LatLng(-7.276590, 112.793885), //sudut
      LatLng(-7.27659, 112.7956982465994), //timur
      LatLng(-7.274791356788162, 112.793885), //utara
    ])) {
      return 3;
    } else if (_isPointInPolygon(position, [
      LatLng(-7.276590, 112.793885), //sudut
      LatLng(-7.274791356788162, 112.793885), //utara
      LatLng(-7.27659, 112.7920717534006), //barat
    ])) {
      return 4;
    }
    return 0;
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;
    for (int i = 0; i < polygon.length; i++) {
      LatLng p1 = polygon[i];
      LatLng p2 = polygon[(i + 1) % polygon.length];
      if ((p1.latitude > point.latitude) != (p2.latitude > point.latitude) &&
          (point.longitude <
              (p2.longitude - p1.longitude) *
                      (point.latitude - p1.latitude) /
                      (p2.latitude - p1.latitude) +
                  p1.longitude)) {
        intersectCount++;
      }
    }
    return intersectCount % 2 == 1;
  }

  void _checkLapCompletion(LatLng position) {
    int detectedQuadrant = _determineQuadrant(position);
    if (detectedQuadrant != 0 && detectedQuadrant != currentQuadrant) {
      setState(() {
        currentQuadrant = detectedQuadrant;
        quadrantSequence.add(detectedQuadrant);

        if (quadrantSequence.join() == '12340') {
          lapCount++;
          quadrantSequence.clear();
        }
      });
    }
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 246),
      appBar: AppBar(
        title: const Text("Dummy Thawaf"),
        titleTextStyle: TextStyle(fontSize: 18),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: currentPosition ?? LatLng(-7.276590, 112.793885),
              zoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885),
                      LatLng(-7.27659, 112.79207175340067),
                      LatLng(-7.278388643211837, 112.793885),
                    ],
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                  ),
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885),
                      LatLng(-7.278388643211837, 112.793885),
                      LatLng(-7.27659, 112.7956982465994),
                    ],
                    color: Colors.red.withOpacity(0.3),
                    borderColor: Colors.red,
                    borderStrokeWidth: 2,
                  ),
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885),
                      LatLng(-7.27659, 112.7956982465994),
                      LatLng(-7.274791356788162, 112.793885),
                    ],
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.green,
                    borderStrokeWidth: 2,
                  ),
                  Polygon(
                    points: [
                      LatLng(-7.276590, 112.793885),
                      LatLng(-7.274791356788162, 112.793885),
                      LatLng(-7.27659, 112.7920717534006),
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
                      builder: (context) => const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  if (startPoint != null)
                    Marker(
                      point: startPoint!,
                      width: 30,
                      height: 30,
                      builder: (context) => const Icon(
                        Icons.star,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Putaran: $lapCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Progres: ${((lapCount / 10) * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: () {
                            if (isTracking) {
                              stopTracking();
                            } else {
                              startTracking();
                            }
                          },
                          child:
                              Icon(isTracking ? Icons.stop : Icons.play_arrow),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
