// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'homepage.dart';
// import 'package:vibration/vibration.dart';

// void main() async {
//   // Ensure Flutter is initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize location service early
//   final locationInitialized = await _initializeLocationService();

//   runApp(MyApp());
// }

// Future<bool> _initializeLocationService() async {
//   try {
//     final Location location = Location();

//     // Print location service status
//     final serviceEnabled = await location.serviceEnabled();
//     print('Location service enabled: $serviceEnabled');

//     if (!serviceEnabled) {
//       final requestResult = await location.requestService();
//       print('Requested location service, result: $requestResult');
//       if (!requestResult) {
//         print('Location service not enabled by user');
//         return false;
//       }
//     }

//     // Check location permission
//     var permissionStatus = await location.hasPermission();
//     print('Initial location permission status: $permissionStatus');

//     if (permissionStatus == PermissionStatus.denied) {
//       permissionStatus = await location.requestPermission();
//       print('Requested permission, new status: $permissionStatus');
//       if (permissionStatus != PermissionStatus.granted) {
//         print('Location permission not granted');
//         return false;
//       }
//     }

//     // Set location settings
//     await location.changeSettings(
//       accuracy: LocationAccuracy.high,
//       interval: 1000,
//       distanceFilter: 0,
//     );

//     print('Location service initialization complete');
//     return true;
//   } catch (e) {
//     print('Error initializing location service: $e');
//     return false;
//   }
// }

// class GPSService {
//   static const EventChannel _streamChannel =
//       EventChannel('com.example.app/gps_stream');

//   Stream<Map<String, double>> getLocationStream() {
//     return _streamChannel.receiveBroadcastStream().map((event) {
//       final map = Map<String, dynamic>.from(event);
//       return {
//         'latitude': map['latitude'],
//         'longitude': map['longitude'],
//       };
//     });
//   }
// }

// class GPSPageUpdate2 extends StatefulWidget {
//   @override
//   _GPSPageUpdate2State createState() => _GPSPageUpdate2State();
// }

// class _GPSPageUpdate2State extends State<GPSPageUpdate2> {
//   LocationData? _currentPosition;
//   LocationData? _previousPosition;
//   int _crossCount = 0;
//   int _completedRounds = 0;
//   bool isTracking = false;
//   List<LatLng> trackPoints = [];
//   LatLng? startPoint;
//   LatLng? currentPosition;

//   Location location = Location();
//   Stream<LocationData>? positionStream;

// // Koordinat untuk bentuk plus
//   final List<LatLng> _polygonCoords = [
//     LatLng(-7.330536, 112.747271), // [0] Pusat
//     LatLng(-7.330886, 112.746879), // [1] Utara
//     LatLng(-7.330892, 112.747547), // [2] Barat
//     LatLng(-7.330252, 112.747590), // [3] Selatan
//     LatLng(-7.330191, 112.746999), // [4] Timur
//   ];

//   @override
//   void initState() {
//     super.initState();

//     GPSService().getLocationStream().listen((location) {
//       final newPosition = LocationData.fromMap({
//         'latitude': location['latitude'],
//         'longitude': location['longitude'],
//         'accuracy': 0.0,
//         'altitude': 0.0,
//         'speed': 0.0,
//         'heading': 0.0,
//         'time': DateTime.now().millisecondsSinceEpoch,
//         'speedAccuracy': 0.0,
//         'altitudeAccuracy': 0,
//         'headingAccuracy': 0,
//       });

//       setState(() {
//         _previousPosition = _currentPosition;
//         _currentPosition = newPosition;

//         if (isTracking) {
//           trackPoints
//               .add(LatLng(newPosition.latitude!, newPosition.longitude!));
//           _checkPolygonCrossing();
//         }
//       });
//     });
//   }

//   // Mengambil lokasi pengguna
//   void _getCurrentLocation() async {
//     // Configure location settings for high accuracy
//     await location.changeSettings(
//       accuracy: LocationAccuracy.high,
//       interval: 1000, // Update interval in milliseconds (1 second)
//       distanceFilter: 0, // Minimum distance (meters) to trigger updates
//     );

//     final position = await location.getLocation().timeout(
//           const Duration(seconds: 10),
//           onTimeout: () => throw TimeoutException('Location request timed out'),
//         );
//     if (position.latitude != null && position.longitude != null) {
//       setState(() {
//         currentPosition = LatLng(position.latitude!, position.longitude!);
//         _currentPosition = position;
//       });
//     }
//   }

//   void _vibrateOnCross() async {
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(duration: 300); // getar 300 ms
//     }
//   }

//   // Mengecek apakah posisi pengguna melewati garis tertentu
//   void _checkPolygonCrossing() {
//     if (_currentPosition == null || _previousPosition == null) {
//       return; // Menunggu posisi yang valid
//     }

//     final LatLng currentLatLng =
//         LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
//     final LatLng previousLatLng =
//         LatLng(_previousPosition!.latitude!, _previousPosition!.longitude!);

//     // sistem anti-double count
//     if (_crossCount == 0 &&
//         _isLineCrossing(previousLatLng, currentLatLng, _polygonCoords[0],
//             _polygonCoords[1])) {
//       setState(() {
//         _crossCount = 1; // Lewat garis Utara
//       });
//       _vibrateOnCross();
//     } else if (_crossCount == 1 &&
//         _isLineCrossing(previousLatLng, currentLatLng, _polygonCoords[0],
//             _polygonCoords[2])) {
//       setState(() {
//         _crossCount = 2; // Lewat garis Barat
//       });
//       _vibrateOnCross();
//     } else if (_crossCount == 2 &&
//         _isLineCrossing(previousLatLng, currentLatLng, _polygonCoords[0],
//             _polygonCoords[3])) {
//       setState(() {
//         _crossCount = 3; // Lewat garis Selatan
//       });
//       _vibrateOnCross();
//     } else if (_crossCount == 3 &&
//         _isLineCrossing(previousLatLng, currentLatLng, _polygonCoords[0],
//             _polygonCoords[4])) {
//       setState(() {
//         _crossCount = 0; // Reset setelah 4/4
//         _completedRounds++; // Tambah 1 putaran
//       });
//       _vibrateOnCross();
//     }

//     // Tampilkan dialog kalau udah 7 putaran
//     if (_completedRounds == 7) {
//       //aku ubah ke 2 dulu buat nyoba, nanti bisa diubah ke 7 lagi
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Thawaf Selesai'),
//           content: Text('Alhamdulillah, kamu telah menyelesaikan 7 putaran.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Tutup'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Memeriksa apakah dua garis saling berpotongan
//   bool _isLineCrossing(LatLng p1, LatLng p2, LatLng v1, LatLng v2) {
//     double d1 = _direction(v1, v2, p1);
//     double d2 = _direction(v1, v2, p2);
//     double d3 = _direction(p1, p2, v1);
//     double d4 = _direction(p1, p2, v2);

//     return (d1 * d2 < 0) && (d3 * d4 < 0);
//   }

//   // Fungsi untuk menghitung arah antara dua garis
//   double _direction(LatLng pi, LatLng pj, LatLng pk) {
//     return (pk.longitude - pi.longitude) * (pj.latitude - pi.latitude) -
//         (pj.longitude - pi.longitude) * (pk.latitude - pi.latitude);
//   }

//   void startTracking() {
//     setState(() {
//       isTracking = true;
//       trackPoints.clear();
//       _crossCount = 0;
//       _completedRounds = 0;
//       if (_currentPosition != null) {
//         trackPoints.add(LatLng(
//           _currentPosition!.latitude!,
//           _currentPosition!.longitude!,
//         ));
//       }
//     });
//     if (_currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Waiting for GPS location...')),
//       );
//       return;
//     }

//     final Location location = Location();
//     positionStream = location.onLocationChanged;
//     positionStream!.listen((LocationData locationData) {
//       if (locationData.latitude != null && locationData.longitude != null) {
//         setState(() {
//           currentPosition =
//               LatLng(locationData.latitude!, locationData.longitude!);
//           _previousPosition = _currentPosition;
//           _currentPosition = LocationData.fromMap({
//             'latitude': locationData.latitude,
//             'longitude': locationData.longitude,
//             'accuracy': locationData.accuracy,
//             'altitude': locationData.altitude,
//             'speed': locationData.speed,
//             'speed_accuracy': locationData.speedAccuracy,
//             'heading': locationData.heading,
//             'time': locationData.time,
//           });

//           isTracking = true;
//           trackPoints.add(currentPosition!);
//         });

//         _checkPolygonCrossing();
//       }
//     });
//   }

//   void stopTracking() {
//     setState(() {
//       isTracking = false;
//     });
//     positionStream = null;
//   }

//   @override
//   void dispose() {
//     positionStream = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: AppBar(
//           centerTitle: true,
//           title: Text(
//             'Thawaf Tracker',
//             style: TextStyle(fontSize: 18),
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFE0F7FA),
//                   Color(0xFFFFFFFF),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Stack(children: [
//         FlutterMap(
//           options: MapOptions(
//             center: LatLng(-7.330536, 112.747271),
//             zoom: 17,
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//               subdomains: ['a', 'b', 'c'],
//             ),
//             PolygonLayer(
//               polygons: [
//                 Polygon(
//                   points: [
//                     LatLng(-7.330536, 112.747271),
//                     LatLng(-7.330886, 112.746879),
//                     LatLng(-7.330892, 112.747547),
//                   ],
//                   color: Colors.blue.withOpacity(0.3),
//                   borderColor: Colors.blue,
//                   borderStrokeWidth: 2,
//                 ),
//                 Polygon(
//                   points: [
//                     LatLng(-7.330536, 112.747271),
//                     LatLng(-7.330892, 112.747547),
//                     LatLng(-7.330252, 112.747590),
//                   ],
//                   color: Colors.red.withOpacity(0.3),
//                   borderColor: Colors.red,
//                   borderStrokeWidth: 2,
//                 ),
//                 Polygon(
//                   points: [
//                     LatLng(-7.330536, 112.747271),
//                     LatLng(-7.330252, 112.747590),
//                     LatLng(-7.330191, 112.746999),
//                   ],
//                   color: Colors.green.withOpacity(0.3),
//                   borderColor: Colors.green,
//                   borderStrokeWidth: 2,
//                 ),
//                 Polygon(
//                   points: [
//                     LatLng(-7.330536, 112.747271),
//                     LatLng(-7.330191, 112.746999),
//                     LatLng(-7.330886, 112.746879),
//                   ],
//                   color: Colors.purple.withOpacity(0.3),
//                   borderColor: Colors.purple,
//                   borderStrokeWidth: 2,
//                 ),
//               ],
//             ),
//             PolylineLayer(
//               polylines: [
//                 if (isTracking)
//                   Polyline(
//                     points: trackPoints,
//                     color: Colors.blue,
//                     strokeWidth: 2.0,
//                   ),
//               ],
//             ),
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: LatLng(_currentPosition!.latitude!,
//                       _currentPosition!.longitude!),
//                   width: 30,
//                   height: 30,
//                   builder: (context) => const Icon(
//                     Icons.location_pin,
//                     color: Colors.blue,
//                     size: 20,
//                   ),
//                 ),
//                 if (startPoint != null)
//                   Marker(
//                     point: LatLng(_currentPosition!.latitude!,
//                         _currentPosition!.longitude!),
//                     width: 30,
//                     height: 30,
//                     builder: (context) => const Icon(
//                       Icons.location_pin,
//                       color: Colors.red,
//                       size: 20,
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//         DraggableScrollableSheet(
//           initialChildSize: 0.3,
//           minChildSize: 0.1,
//           maxChildSize: 0.5,
//           builder: (context, controller) {
//             return Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color(0xFFE0F7FA),
//                     Color(0xFFFFFFFF),
//                   ],
//                 ),
//               ),
//               child: ListView(
//                 controller: controller,
//                 children: [
//                   SizedBox(height: 12),
//                   Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Progress Thawaf: ${_crossCount}/4',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Jumlah Putaran',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         Text(
//                           '$_completedRounds',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'putaran',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         Positioned(
//           bottom: 16,
//           right: 16,
//           child: FloatingActionButton(
//             onPressed: () {
//               if (isTracking) {
//                 stopTracking();
//               } else {
//                 startTracking();
//               }
//             },
//             backgroundColor: Colors.cyan,
//             child: Icon(
//               isTracking ? Icons.stop : Icons.play_arrow,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
