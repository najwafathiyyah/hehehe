import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // hasil flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(InputLocationApp());
}

class InputLocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input Location Data',
      home: InputLocationScreen(),
    );
  }
}

class InputLocationScreen extends StatefulWidget {
  @override
  State<InputLocationScreen> createState() => _InputLocationScreenState();
}

class _InputLocationScreenState extends State<InputLocationScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  DateTime? _selectedTimestamp;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedTimestamp = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _addLocationData() async {
    if (_selectedTimestamp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih timestamp dulu')),
      );
      return;
    }

    try {
      await _db.collection('locations').add({
        'userId': _userIdController.text,
        'latitude': double.parse(_latitudeController.text),
        'longitude': double.parse(_longitudeController.text),
        'timestamp': Timestamp.fromDate(_selectedTimestamp!),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil ditambahkan')),
      );
      _clearFields();
    } catch (e) {
      print('Error adding data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan data: $e')),
      );
    }
  }

  void _clearFields() {
    _userIdController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    setState(() {
      _selectedTimestamp = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Lokasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                _selectedTimestamp == null
                    ? 'Pilih Timestamp'
                    : 'Timestamp: ${_selectedTimestamp.toString()}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLocationData,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
