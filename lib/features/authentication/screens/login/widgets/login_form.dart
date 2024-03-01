import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:fvapp/features/authentication/screens/signup/signup.dart';
import 'package:fvapp/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class FVLoginForm extends StatelessWidget {
  const FVLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FVSizes.spaceBtwSection),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: FVText.email,
              ),
            ),
            const SizedBox(
              height: FVSizes.spaceBtwInputFields,
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: FVText.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
            const SizedBox(
              height: FVSizes.spaceBtwInputFields / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(FVText.rememberMe),
                  ],
                ),

                // Forgot Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPassword()),
                  child: const Text(FVText.forgotPassword),
                ),
              ],
            ),
            const SizedBox(
              height: FVSizes.spaceBtwSection,
            ),

            // Sign in Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const NavigationMenu()),
                child: const Text(FVText.signIn),
              ),
            ),
            const SizedBox(
              height: FVSizes.spaceBtwItems,
            ),

            // Create Account
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(FVText.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
