import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisata Bandung',
      theme: ThemeData(),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FirstScreen(); // Pastikan FirstScreen sudah diimport
                        }));
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
                      onPressed: () {},
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

              // TextField Nama Lengkap
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15), // Margin samping 24
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'No. Telepon',
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

              // TextField Nama Lengkap
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 15), // Margin samping 24
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'ID Passport',
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

              // TextField Nama Lengkap
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
              const SizedBox(height: 12),

              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20), // Margin samping 20
                child: const Text(
                  'Jenis Kelamin',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 2),

              // Jarak antara label dan radio buttons
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 5), // Margin samping 20
                child: Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'Pria',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text('Pria'),
                    const SizedBox(width: 20),
                    Radio<String>(
                      value: 'Wanita',
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const Text('Wanita'),
                  ],
                ),
              ),

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
                      return FirstScreen();
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
                        'Daftar',
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              Colors.white, // Mengubah warna teks menjadi putih
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
