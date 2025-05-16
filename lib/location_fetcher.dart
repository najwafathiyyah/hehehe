import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationFetcher {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi buat ngambil data lokasi semua user secara realtime
  Stream<List<Map<String, dynamic>>> getAllUserLocations() {
    return _firestore.collection('user_locations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'latitude': data['latitude'] ?? 0.0,
          'longitude': data['longitude'] ?? 0.0,
        };
      }).toList();
    });
  }

  Future<void> addDummyLocation() async {
    await FirebaseFirestore.instance
        .collection('user_locations')
        .doc('user123')
        .set({
      'latitude': -7.330520,
      'longitude': 112.747260,
    });
  }
}
