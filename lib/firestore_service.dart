import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addlocations(
      Int latitude, Int longitude, String userId, Timestamp timestamp) async {
    await firestore.collection('locations').add({
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    });
  }

  Stream<List<Map<String, dynamic>>> getlocations() {
    return firestore.collection('locations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'userId': doc['userId'],
          'latitude': doc['latitude'],
          'longitude': doc['longitude'],
          'timestamp': doc['timestamp'],
        };
      }).toList();
    });
  }
}
