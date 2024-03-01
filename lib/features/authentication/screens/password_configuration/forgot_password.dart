import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              FVText.forgotPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: FVSizes.spaceBtwItems),
            Text(
              FVText.forgotPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: FVSizes.spaceBtwSection * 2),

            // Text Field
            TextFormField(
              decoration: const InputDecoration(
                  labelText: FVText.email,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: FVSizes.spaceBtwSection),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.off(() => const ResetPassword()),
                child: const Text(FVText.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
