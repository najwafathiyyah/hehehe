import 'package:flutter/material.dart';
import 'secondpage.dart';
import 'homepage.dart';
import 'thawaf_tracker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Muthawif',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "E-Muthawif",
            style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(
                    255, 255, 255, 255) // Ubah ukuran font sesuai kebutuhan
                ),
          ),
          centerTitle: true, // Menempatkan judul di tengah
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Memusatkan konten secara vertikal
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Memastikan elemen mengisi lebar yang tersedia
              children: <Widget>[
                // Logo
                Image.asset(
                  'assets/images/logo.png', // Sesuaikan dengan path logo Anda
                  height: 100, // Sesuaikan ukuran logo
                ),
                const SizedBox(height: 16), // Jarak antara logo dan teks

                // Judul
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

                // Deskripsi
                const Text(
                  'Buat akun atau masuk untuk menjelajahi aplikasi kami',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors
                          .grey // Menyesuaikan ukuran font agar lebih terbaca
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Tombol Masuk dan Daftar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15), // Margin samping 24
                      child: TextButton(
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors
                                  .black), // Mengubah warna teks menjadi hitam
                        ),
                        onPressed: () {
                          // Aksi untuk tombol Masuk
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15), // Margin samping 24
                      child: TextButton(
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors
                                  .black), // Mengubah warna teks menjadi hitam
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignUpPage();
                          }));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

// TextField Nama Lengkap
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15), // Margin samping 24
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      labelStyle: TextStyle(
                        fontSize: 16, // Mengubah ukuran teks label
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Mengubah corner radius
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

// TextField NIK
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15), // Margin samping 24
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'NIK',
                      labelStyle: TextStyle(
                        fontSize: 16, // Mengubah ukuran teks label
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Mengubah corner radius
                      ),
                    ),
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
