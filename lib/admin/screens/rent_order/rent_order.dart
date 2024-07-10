import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/admin/screens/chat/chat_list.dart';
import 'package:fvapp/admin/screens/rent_order/widgets/rent_detail.dart';

class RentalItem extends StatelessWidget {
  final String rentalName;
  final String packageName;
  final String status;
  final VoidCallback onTap;

  const RentalItem({
    Key? key,
    required this.rentalName,
    required this.packageName,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  Color getStatusColor(String status) {
    switch (status) {
      case 'Belum Lunas':
        return Colors.orange;
      case 'Lunas':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: FVColors.grey),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: TextStyle(
                fontSize: 14.0,
                color: getStatusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rentalName,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              packageName,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RentalList extends StatefulWidget {
  @override
  _RentalListState createState() => _RentalListState();
}

class _RentalListState extends State<RentalList> {
  final RentController _rentController = Get.find<RentController>(); // Gunakan Get.find untuk mendapatkan instance yang sudah diinisialisasi

  late Future<List<Rent>> _rentsFuture;

  @override
  void initState() {
    super.initState();
    _rentsFuture = _rentController.getRents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Sewa'),
      ),
      body: FutureBuilder<List<Rent>>(
        future: _rentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator());
} else if (snapshot.hasError) {
  return Center(child: Text('Error: ${snapshot.error}'));
} else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return Center(child: Text('No rentals found'));
} else {
  List<Rent> rents = snapshot.data!;
  return ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: rents.length,
    itemBuilder: (context, index) {
      Rent rent = rents[index];
      return RentalItem(
        rentalName: rent.userName,
        packageName: rent.packageName,
        status: rent.status,
        onTap: () => Get.to(() => RentDetail(rentId: rent.id)),
      );
    },
  );
}

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            UserModel userModel = await getCurrentUser();
            print('User data: ${userModel.toJson()}');
            if (userModel.role == 'admin') {
              Get.to(() => AdminChatListScreen());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Anda tidak memiliki akses ke fitur ini.')),
              );
            }
          } catch (e) {
            print('Error getting current user: ${e.toString()}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          }
        },
        child: const Icon(Iconsax.messages),
        backgroundColor: FVColors.gold,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Future<UserModel> getCurrentUser() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('User not logged in');
    throw Exception('User not logged in');
  }

  print('Current user ID: ${user.uid}');

  final doc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
  if (!doc.exists) {
    print('User document does not exist for ID: ${user.uid}');
    throw Exception('User document does not exist');
  }

  print('User document found: ${doc.data()}');
  return UserModel.fromSnapshot(doc);
}
