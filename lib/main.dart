import 'package:flutter/material.dart';
import 'secondpage.dart';
import 'homepage.dart';
import 'thawaf_tracker.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.transparent, // Membuat latar belakang transparan
      ),
      home: FirstScreen(),
    ),
  );
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isRegisterSelected = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE0F7FA),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mulailah Sekarang',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Buat akun atau masuk untuk menjelajahi aplikasi kami',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  /// Tombol masuk dan daftar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegisterSelected = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isRegisterSelected
                                      ? Colors.white
                                      : Colors.cyan,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isRegisterSelected
                                        ? Colors.cyan
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpPage()), // Ganti dengan nama halaman kamu
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isRegisterSelected
                                      ? Colors.cyan
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isRegisterSelected
                                        ? Colors.white
                                        : Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

// TextField Nama Lengkap
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            isDense:
                                true, // Penting! Biar TextField jadi compact
                            //hintText: 'Tulis nama lengkap anda...',
                            //hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8, // Ubah ini buat atur tinggi
                              horizontal: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

// TextField NIK
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NIK',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            isDense:
                                true, // Penting! Biar TextField jadi compact
                            //hintText: 'Tulis nama lengkap anda...',
                            //hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8, // Ubah ini buat atur tinggi
                              horizontal: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),

// Checkbox Ingat Saya
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15), // Margin samping 24
                    child: RememberMeCheckbox(),
                  ),
                  const SizedBox(height: 2),

                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15), // Margin samping 15
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets
                            .zero, // Menghilangkan padding default ElevatedButton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Mengubah border radius menjadi 10
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(
                                  255, 144, 224, 239), // Warna awal gradasi
                              Color.fromARGB(
                                  255, 0, 180, 216), // Warna akhir gradasi
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // Border radius untuk gradasi
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10), // Padding tombol
                          alignment: Alignment.center, // Menengahkan teks
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors
                                  .white, // Mengubah warna teks menjadi putih
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 170),

                  // Persyaratan Layanan
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 39.0), // Margin samping
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dengan mendaftar, Anda menyetujui ',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Persyaratan Layanan ',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'dan ',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Perjanjian Pemrosesan Data',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RememberMeCheckbox extends StatefulWidget {
  @override
  _RememberMeCheckboxState createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale:
              0.8, // Mengubah ukuran checkbox (0.8 artinya lebih kecil dari default)
          child: Checkbox(
            value: _isChecked,
            onChanged: (bool? newValue) {
              setState(() {
                _isChecked = newValue ?? false;
              });
            },
          ),
        ),
        const SizedBox(width: 8), // Spasi antara checkbox dan teks
        Text(
          'Ingat saya',
          style: TextStyle(fontSize: 12), // Mengubah ukuran tulisan
        ),
      ],
    );
  }
}
