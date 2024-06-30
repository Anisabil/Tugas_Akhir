import 'package:firebase_database/firebase_database.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';

class RentController {
  final DatabaseReference _rentRef = FirebaseDatabase.instance.reference().child('rents');

  Future<void> addRent(Rent rent) async {
    try {
      if (rent.packageName.isEmpty || rent.packageId.isEmpty) {
        throw Exception('Package name or package ID is null or invalid');
      }
      await _rentRef.push().set(rent.toMap());
    } catch (e) {
      throw Exception('Failed to add rent: $e');
    }
  }
Future<List<Rent>> getRentsByUserId(String userId) async {
  try {
    DataSnapshot snapshot = await _rentRef.orderByChild('userId').equalTo(userId).get();
    if (snapshot.exists && snapshot.value != null) {
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

  Future<List<Rent>> getRents() async {
    try {
      DataSnapshot snapshot = await _rentRef.once().then((event) => event.snapshot);
      if (snapshot.value != null) {
        Map<String, dynamic> rentsData = Map<String, dynamic>.from(snapshot.value as Map);
        List<Rent> rents = [];
        for (var key in rentsData.keys) {
          var rentMap = Map<String, dynamic>.from(rentsData[key]);
          rents.add(Rent.fromMap(rentMap));
        }
        return rents;
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading rents: $e');
      throw Exception('Failed to load rents: $e');
    }
  }

  Future<Rent?> getRentById(String rentId) async {
    try {
      DataSnapshot snapshot = await _rentRef.orderByChild('id').equalTo(rentId).get();
      if (snapshot.exists) {
        Map<String, dynamic> rentsData = Map<String, dynamic>.from(snapshot.value as Map);
        if (rentsData.isNotEmpty) {
          return Rent.fromMap(Map<String, dynamic>.from(rentsData.values.first));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load rent: $e');
    }
  }

  Future<void> updateRentStatus(String rentId, String newStatus) async {
    try {
      await _rentRef.child(rentId).update({'status': newStatus});
    } catch (e) {
      throw Exception('Failed to update rent status: $e');
    }
  }
}
