import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Muthawif Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ThawafTrackingScreen(),
    );
  }
}

class ThawafTrackingScreen extends StatefulWidget {
  @override
  _ThawafTrackingScreenState createState() => _ThawafTrackingScreenState();
}

class _ThawafTrackingScreenState extends State<ThawafTrackingScreen> {
  Position? _currentPosition;
  Position? _previousPosition;
  int _crossCount = 0;
  int _completedRounds = 0;
  bool isTracking = false;
  List<LatLng> trackPoints = [];
  LatLng? startPoint;
  LatLng? currentPosition;
  StreamSubscription<Position>? positionStream;
  String trackingMode = 'Real'; // langsung isi default

  // Koordinat untuk bentuk plus
  final List<LatLng> _polygonCoords = [
    LatLng(-7.276590, 112.793885), // Tengah
    LatLng(-7.274791356788162, 112.793885), // Utara
    LatLng(-7.278388643211837, 112.793885), // Selatan
    LatLng(-7.27659, 112.7956982465994), // Timur
    LatLng(-7.27659, 112.7920717534006), // Barat
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    isTracking = false;
    trackPoints = [];
  }

  // Mengambil lokasi pengguna
  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy:
          LocationAccuracy.bestForNavigation, // Replace with desired accuracy
      distanceFilter: 10, // Minimum distance before an update is triggered
    );

    final position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      _currentPosition = position;
    });
  }

  // Mengecek apakah posisi pengguna melewati garis tertentu
  void _checkPolygonCrossing() {
    if (_currentPosition == null || _previousPosition == null) {
      return; // Menunggu posisi yang valid
    }

    final LatLng currentLatLng =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    final LatLng previousLatLng =
        LatLng(_previousPosition!.latitude, _previousPosition!.longitude);

    // Cek crossing antara pusat dan setiap titik
    if (_isLineCrossing(
        previousLatLng, currentLatLng, _polygonCoords[0], _polygonCoords[2])) {
      setState(() {
        _crossCount = 1; // Sa'i 1/4
      });
    } else if (_isLineCrossing(
        previousLatLng, currentLatLng, _polygonCoords[0], _polygonCoords[3])) {
      setState(() {
        _crossCount = 2; // Sa'i 2/4
      });
    } else if (_isLineCrossing(
        previousLatLng, currentLatLng, _polygonCoords[0], _polygonCoords[1])) {
      setState(() {
        _crossCount = 3; // Sa'i 3/4
      });
    } else if (_isLineCrossing(
        previousLatLng, currentLatLng, _polygonCoords[0], _polygonCoords[4])) {
      setState(() {
        _crossCount = 4; // Sa'i 4/4
        _completedRounds++;
        _crossCount = 0; // Reset ke awal
      });
    }
  }

  // Memeriksa apakah dua garis saling berpotongan
  bool _isLineCrossing(LatLng p1, LatLng p2, LatLng v1, LatLng v2) {
    double d1 = _direction(v1, v2, p1);
    double d2 = _direction(v1, v2, p2);
    double d3 = _direction(p1, p2, v1);
    double d4 = _direction(p1, p2, v2);

    return (d1 * d2 < 0) && (d3 * d4 < 0);
  }

  // Fungsi untuk menghitung arah antara dua garis
  double _direction(LatLng pi, LatLng pj, LatLng pk) {
    return (pk.longitude - pi.longitude) * (pj.latitude - pi.latitude) -
        (pj.longitude - pi.longitude) * (pk.latitude - pi.latitude);
  }

  void startTracking() {
    setState(() {
      isTracking = true;
      _crossCount = 0;
      _completedRounds = 0;
      trackPoints.clear();

      if (_currentPosition != null) {
        trackPoints.add(LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ));
      }
    });

    if (trackingMode == 'Real') {
      // REAL GPS Tracking
      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waiting for GPS location...')),
        );
        return;
      }

      positionStream =
          Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          currentPosition = LatLng(position.latitude, position.longitude);
          _previousPosition = _currentPosition; // Simpan posisi sebelumnya
          _currentPosition = position;
          isTracking = true;
          trackPoints.add(currentPosition!); // Menyimpan track posisi
        });

        _checkPolygonCrossing(); // Memeriksa crossing
      });
    } else if (trackingMode == 'Real New') {
      // REAL GPS Tracking
      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
        ),
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
          trackPoints.add(LatLng(position.latitude, position.longitude));
          _checkPolygonCrossing();
        });
      });
    }
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
    if (_currentPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Thawaf Tracker'),
        ),
        body: Center(child: CircularProgressIndicator()), // Menunggu lokasi
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Thawaf Tracker'),
      ),
      body: Stack(children: [
        FlutterMap(
          options: MapOptions(
            center:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 17,
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
                      Icons.location_pin,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ],
        ),

        // ✅ Sekarang Positioned udah di dalam children
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: DropdownButton<String>(
              value: trackingMode,
              underline: Container(),
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (String? newValue) {
                setState(() => trackingMode = newValue!);
              },
              items: ['Real', 'Real New'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.5,
          builder: (context, controller) {
            return Container(
              color: Colors.white,
              child: ListView(
                controller: controller,
                children: [
                  ListTile(
                    title: Text(
                      'Progress Thawaf: $_crossCount/4',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Putaran Selesai: $_completedRounds kali',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              if (isTracking) {
                stopTracking();
              } else {
                startTracking();
              }
            },
            child: Icon(isTracking ? Icons.stop : Icons.play_arrow),
          ),
        ),
      ]),
    );
  }
}
