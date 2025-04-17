import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
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
  bool isRegisterSelected = true; // taruh di State

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Selamat Datang di Aplikasi e-Muthawif!',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Nikmati pengalaman yang nyaman dan menyenangkan bersama kami.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),

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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FirstScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                decoration: BoxDecoration(
                                  color: !isRegisterSelected
                                      ? Colors.cyan
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: !isRegisterSelected
                                        ? Colors.white
                                        : Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4), // pemisah kecil
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRegisterSelected = true;
                                });
                                // Aksi untuk tombol Daftar
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
                  const SizedBox(height: 30),

                  _buildTextField(context, 'Nama Lengkap'),
                  const SizedBox(height: 12),
                  _buildTextField(context, 'No. Telepon'),
                  const SizedBox(height: 12),
                  _buildTextField(context, 'Email'),
                  const SizedBox(height: 12),
                  _buildTextField(context, 'NIK'),
                  const SizedBox(height: 12),
                  _buildTextField(context, 'No. Paspor'),
                  const SizedBox(height: 12),

                  // Jenis Kelamin
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jenis Kelamin',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Pria',
                                    groupValue: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    },
                                  ),
                                  const Text('Pria'),
                                ],
                              ),
                              const SizedBox(width: 30),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Wanita',
                                    groupValue: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value!;
                                      });
                                    },
                                  ),
                                  const Text('Wanita'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Daftar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                              Color.fromARGB(255, 144, 224, 239),
                              Color.fromARGB(255, 0, 180, 216),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
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
        ),
      ),
    );
  }

  // Fungsi bantu buat textfield biar gak ngulang-ngulang
  Widget _buildTextField(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            ),
          ),
        ],
      ),
    );
  }
}
