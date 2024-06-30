import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/rent_order/widgets/rent_detail.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';

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
      case 'In Progress':
        return Colors.orange;
      case 'Completed':
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
  final RentController _rentController = RentController();
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
        onPressed: () {},
        child: const Icon(Iconsax.messages),
        backgroundColor: FVColors.gold,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
