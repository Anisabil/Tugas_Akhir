import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/rent_order/widgets/rent_detail.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RentalItem extends StatelessWidget {
  final String rentalName;
  final String packageName;
  final VoidCallback onTap;

  const RentalItem({
    Key? key,
    required this.rentalName,
    required this.packageName,
    required this.onTap,
  }) : super(key: key);

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

class RentalList extends StatelessWidget {
  final List<Map<String, String>> dummyRentalData = [
    {'name': 'John Doe', 'package': 'Wedding Package'},
    {'name': 'Jane Doe', 'package': 'Birthday Package'},
    {'name': 'Alice Smith', 'package': 'Corporate Event Package'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: dummyRentalData.length,
        itemBuilder: (context, index) {
          return RentalItem(
            rentalName: dummyRentalData[index]['name']!,
            packageName: dummyRentalData[index]['package']!,
            onTap: () => Get.to(() => const RentDetail()),
          );
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

