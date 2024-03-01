import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/success_screen/success_screen.dart';
import 'package:fvapp/features/authentication/screens/login/login.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/helper_function.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(FVImages.emailIlustration),
                width: FVHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Title
              Text(
                FVText.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),
              Text(
                'anisabilathar3@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),
              Text(
                FVText.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(
                    () => SuccessScreen(
                      image: FVImages.successIlustration,
                      title: FVText.yourAccountCreatedTitle,
                      subTitle: FVText.yourAccountCreatedSubTitle,
                      onPressed: () => Get.to(() => const LoginScreen()),
                    ),
                  ),
                  child: const Text(FVText.fvContinue)),
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {}, child: const Text(FVText.resendEmail)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
