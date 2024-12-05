import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ThawafPage(), // Halaman pertama yang akan ditampilkan
    );
  }
}

class ThawafPage extends StatelessWidget {
  const ThawafPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thawaf'),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomePage()),
      //       );
      //     },
      //     child: const Text('Mulai'),
      //   ),
      // ),
    );
  }
}

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navbar1(),
    );
  }
}

class Navbar1 extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<Navbar1> {
  int _selectedIndex = 0;

  // Daftar halaman yang ditampilkan
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Halaman 1: Home', style: TextStyle(fontSize: 24)),
    Text('Halaman 2: Profile', style: TextStyle(fontSize: 24)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengganti halaman berdasarkan index yang diklik
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Bar Example'),
      ),
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex), // Menampilkan halaman sesuai index
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Ketika item ditekan, index halaman akan berubah
      ),
    );
  }
}
