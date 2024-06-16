import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';

class OrderScreen extends StatelessWidget {
  final String userId;
  const OrderScreen({super.key, required this.userId});

  Future<List<Rent>> fetchRents() async {
    final rentRef = FirebaseDatabase.instance.ref().child('rents');
    final query = rentRef.orderByChild('userId').equalTo(userId);
    final snapshot = await query.get();

    if (snapshot.exists) {
      final rents = <Rent>[];
      for (var child in snapshot.children) {
        final data = Map<String, dynamic>.from(child.value as Map);
        rents.add(Rent.fromMap(data));
      }
      return rents;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Sewa'),
      ),
      body: FutureBuilder<List<Rent>>(
        future: fetchRents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data sewa.'));
          } else {
            final rents = snapshot.data!;
            return ListView.builder(
              itemCount: rents.length,
              itemBuilder: (context, index) {
                final rent = rents[index];
                return ListTile(
                  title: Text(rent.packageId),
                  subtitle: Text(rent.date.toIso8601String()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
