import 'package:cloud_firestore/cloud_firestore.dart';

// Ini class buat ambil semua posisi user dari Firestore secara realtime
class LocationFetcher {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi ini mantau collection 'locations' terus-terusan
  Stream<List<Map<String, dynamic>>> getAllUserLocations() {
    return _firestore.collection('locations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Setiap user punya: id, latitude, longitude, dan jumlah putaran
        return {
          'userId': doc.id,
          'latitude': data['latitude'],
          'longitude': data['longitude'],
          'roundCount': data['roundCount'],
        };
      }).toList();
    });
  }
}
