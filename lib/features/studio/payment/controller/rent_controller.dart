import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:http/http.dart' as http;

class RentController {
  late DatabaseReference _rentRef;

  RentController() {
    _rentRef = FirebaseDatabase.instance.ref().child('rents');
  }

  Future<void> addRent(Rent rent) async {
    try {
      await _rentRef.push().set(rent.toMap());
    } catch (e) {
      throw Exception('Failed to add rent: $e');
    }
  }

  Future<List<Rent>> getRentsByUserId(String userId) async {
    try {
      DataSnapshot snapshot = await _rentRef.orderByChild('userId').equalTo(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic> rentsData = Map<String, dynamic>.from(snapshot.value as Map);
        return rentsData.values.map((rentData) {
          return Rent.fromMap(Map<String, dynamic>.from(rentData));
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load rents: $e');
    }
  }
}
