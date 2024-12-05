import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'thawaf_map.dart';

class ThawafTracker extends StatefulWidget {
  @override
  _ThawafTrackerState createState() => _ThawafTrackerState();
}

class _ThawafTrackerState extends State<ThawafTracker> {
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.requestPermission();

    if (serviceEnabled && permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      positionStream =
          Geolocator.getPositionStream().listen((Position position) {
        print(position); // Cek posisi pengguna
        _checkQuadrant(position);
      });
    }
  }

  void _checkQuadrant(Position position) {
    // Logika untuk memeriksa kuadran mana yang sedang ditempati oleh pengguna.
    // Tambahkan penghitung kuadran atau putaran sesuai perubahan kuadran.
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThawafMap(); // Tampilkan widget peta
  }
}
