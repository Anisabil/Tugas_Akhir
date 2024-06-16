import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/controllers/signup/signup_controller.dart';
import 'package:fvapp/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';

class FVSignupForm extends StatelessWidget {
  const FVSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      FVValidator.validateEmptyText('Nama depan', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: FVText.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: FVSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      FVValidator.validateEmptyText('Nama belakang', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: FVText.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: FVSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            controller: controller.userName,
            validator: (value) =>
                FVValidator.validateEmptyText('Nama pengguna', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: FVText.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: FVSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => FVValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: FVText.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: FVSizes.spaceBtwInputFields),

          // Phone number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => FVValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: FVText.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: FVSizes.spaceBtwInputFields),

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
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: FVSizes.spaceBtwInputFields),

          // Terms&conditions Checkbox
          const FVTermsAndConditionCheckbox(),
          const SizedBox(height: FVSizes.spaceBtwSection),

          // Signup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(FVText.createAccount),
            ),
          )
        ],
      ),
    );
  }
}
