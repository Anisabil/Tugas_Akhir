import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/features/studio/screens/event/event.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/features/studio/chat/chat.dart';

class FVBottomAddToCart extends StatelessWidget {
  final Package package;
  final String packageId;

  const FVBottomAddToCart({
    Key? key,
    required this.package, required this.packageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: FVSizes.defaultSpace, vertical: FVSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? FVColors.darkerGrey : FVColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(FVSizes.cardRadiusLg),
          topRight: Radius.circular(FVSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              try {
                UserModel userModel = await getCurrentUser();
                if (userModel.role == 'admin' || userModel.role == 'client') {
                  Get.to(() => ChatScreen(
                      receiverId:
                          'admin')); // Gunakan 'admin' sebagai ID fotografer
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Anda tidak memiliki akses ke fitur ini.')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(FVSizes.md),
              backgroundColor: FVColors.black,
              side: const BorderSide(color: FVColors.black),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.messages),
                SizedBox(width: 2),
                Text('Hubungi Admin'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => EventScreen(
                    package: package,
                    packageId: packageId,
                  ));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(FVSizes.md),
              backgroundColor: FVColors.black,
              side: const BorderSide(color: FVColors.black),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.calendar_add),
                SizedBox(width: 5),
                Text('Sewa'),
              ],
            ),
          )
        ],
      ),
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

  final doc =
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
  if (!doc.exists) {
    print('User document does not exist for ID: ${user.uid}');
    throw Exception('User document does not exist');
  }

  print('User document found: ${doc.data()}');
  return UserModel.fromSnapshot(doc);
}
