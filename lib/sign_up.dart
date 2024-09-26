import 'package:flutter/material.dart';

void main() {
  runApp(SignUpPage());
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png',
            height: 50), // Sesuaikan path gambar
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Mulailah Sekarang',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Buat akun atau masuk untuk menjelajahi aplikasi kami',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman masuk
                  },
                  child: Text('Masuk', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'ID Passport',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'NIK',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Jenis Kelamin'),
                SizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      Radio(
                          value: 'Pria',
                          groupValue: null,
                          onChanged: (String? value) {}),
                      Text('Pria'),
                      SizedBox(width: 20),
                      Radio(
                          value: 'Wanita',
                          groupValue: null,
                          onChanged: (String? value) {}),
                      Text('Wanita'),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk sign up
              },
              child: Text('Daftar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
