import 'package:flutter/material.dart';
import 'main.dart';
import 'thawafpage.dart';
import 'saipage.dart';
import 'thawaf_map.dart';
import 'thawaf_tracker.dart';
import 'dummythawaf.dart';
import 'dummysai.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _Homepage1 createState() => _Homepage1();
}

class _Homepage1 extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          // Menggunakan Column untuk menempatkan tombol secara vertikal
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              child: const Text('Thawaf'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ThawafMap();
                }));
                // Aksi untuk tombol Thawaf
              },
            ),
            const SizedBox(height: 20), // Menambahkan jarak antara tombol
            OutlinedButton(
              child: const Text('Sa\'i'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SaiPage();
                }));
                // Aksi untuk tombol Sa'i
              },
            ),
            const SizedBox(height: 20), // Menambahkan jarak antara tombol
            OutlinedButton(
              child: const Text('Dummy Thawaf'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DummyThawafPage();
                }));
                // Aksi untuk tombol Dummy Thawaf
              },
            ),
            const SizedBox(height: 20), // Menambahkan jarak antara tombol
            OutlinedButton(
              child: const Text('Dummy Sa\'i'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DummySaiPage();
                }));
                // Aksi untuk tombol Dummy Sa'i
              },
            ),
          ],
        ),
      ),
    );
  }
}
