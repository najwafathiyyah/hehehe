import 'package:flutter/material.dart';
import 'thawafpage.dart';
import 'saipage.dart';
import 'thawaf_map.dart';
import 'thawaf_tracker.dart';
import 'dummythawaf.dart';
import 'dummysai.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting time
import 'package:geolocator/geolocator.dart'; // For getting location
import 'package:geocoding/geocoding.dart'; // For reverse geocoding
import 'reallocation1.dart';
import 'reallocation2.dart';
import 'koni_google.dart';
import 'koni_maps.dart';
import 'devy1.dart';
import 'devy2.dart';
import 'cobadevy1.dart';
import 'rumahcua.dart';

void main() {
  runApp(HomePage());
}

class MyApp extends StatelessWidget {
  // Hapus `const` pada konstruktor jika tidak perlu
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE0F7FA), // soft blue
                Color(0xFFFFFFFF), // white
              ],
            ),
          ),
          child: const HomeContent(),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedMenu(String title, Widget page) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Home Page',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40.0),
            LocationAndTimeWidget(),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _buildAnimatedMenu('Thawaf', ThawafMap()),
                  _buildAnimatedMenu('Sa\'i', SaiPage()),
                  _buildAnimatedMenu('Dummy Thawaf', DummyThawafPage()),
                  _buildAnimatedMenu('Dummy Sa\'i', DummySaiPage()),
                  _buildAnimatedMenu('Dummy Real Location 1', Reallocation1()),
                  _buildAnimatedMenu('Dummy Real Location 2', Reallocation2()),
                  _buildAnimatedMenu('Koni Google Earth', KoniGooglePage()),
                  _buildAnimatedMenu('Koni GPS', KoniMapsPage()),
                  _buildAnimatedMenu('Devy 1', ThawafTrackingScreen()),
                  _buildAnimatedMenu('Devy 2', Devy2()),
                  _buildAnimatedMenu('Coba Devy 1', cobadevy1()),
                  _buildAnimatedMenu('rumahcua', rumahcua())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationAndTimeWidget extends StatefulWidget {
  @override
  _LocationAndTimeWidgetState createState() => _LocationAndTimeWidgetState();
}

class _LocationAndTimeWidgetState extends State<LocationAndTimeWidget> {
  String _currentLocation = "Fetching location...";
  String _currentTime = "Fetching time...";

  @override
  void initState() {
    super.initState();
    _getLocation();
    _updateTime();
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Location permissions are permanently denied.";
      });
      return;
    }

    try {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, // Replace with desired accuracy
        distanceFilter: 0, // Minimum distance before an update is triggered
      );

      final position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _currentLocation = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _currentLocation = "Failed to get location.";
      });
    }
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('hh:mm a').format(DateTime.now());
    });
    Future.delayed(const Duration(minutes: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Location: $_currentLocation",
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Time: $_currentTime",
                  style: const TextStyle(fontSize: 16.0, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
