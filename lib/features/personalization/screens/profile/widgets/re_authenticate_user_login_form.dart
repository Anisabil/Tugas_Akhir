import 'package:flutter/material.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:fvapp/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Mengautentikasi ulang pengguna')),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: Form(
          key: controller.reAuthFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email
              TextFormField(
                controller: controller.verifyEmail,
                validator: FVValidator.validateEmail,
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: FVText.email),
              ),
              const SizedBox(height: FVSizes.spaceBtwInputFields),

              // Password
              Obx(() => 
                TextFormField(
                  obscureText: controller.hidePassword.value,
                  controller: controller.verifyPassword,
                  validator: (value) => FVValidator.validateEmptyText('Password', value),
                  decoration: InputDecoration(
                    labelText: FVText.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value, 
                      icon: const Icon(Iconsax.eye_slash),
                    )
                  ),
                )
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // LOGIN Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),
                  child: const Text('Verify'),
                ),
              ),
            ],
          )
        ),
        ),
      ),
    );
  }
}