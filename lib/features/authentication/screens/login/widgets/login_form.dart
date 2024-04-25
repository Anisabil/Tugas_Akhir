import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/controllers/login/login_controller.dart';
import 'package:fvapp/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:fvapp/features/authentication/screens/signup/signup.dart';
import 'package:fvapp/utils/validators/validation.dart';
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
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FVSizes.spaceBtwSection),
        child: Column(
          children: [
            // email
            TextFormField(
              controller: controller.email,
              validator: (value) => FVValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: FVText.email,
              ),
            ),
            const SizedBox(
              height: FVSizes.spaceBtwInputFields,
            ),

            // Password
            Obx(
              () => TextFormField(
                validator: (value) => FVValidator.validatePassword(value),
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: FVText.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: FVSizes.spaceBtwInputFields / 2,
            ),

            // Remenber Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value),
                    ),
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
                onPressed: () => controller.emailAndPasswordSignIn(),
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
