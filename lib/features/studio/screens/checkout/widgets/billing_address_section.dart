import 'package:flutter/material.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';

class FVBillingAddressSection extends StatelessWidget {
  final Map<String, dynamic> formData;
  const FVBillingAddressSection({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return FutureBuilder<UserModel?>(
      future: userController.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data available');
        } else {
          final user = snapshot.data!;
          print('User data in FVBillingAddressSection: ${user.toJson()}');
          
          formData['clientEmail'] = user.email;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_2,
                    color: FVColors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: FVSizes.spaceBtwItems),
                  Text(user.userName,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: FVSizes.spaceBtwItems / 2),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: FVColors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: FVSizes.spaceBtwItems),
                  Text(user.phoneNumber,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: FVSizes.spaceBtwItems / 2),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    color: FVColors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: FVSizes.spaceBtwItems),
                  Text(user.email,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
