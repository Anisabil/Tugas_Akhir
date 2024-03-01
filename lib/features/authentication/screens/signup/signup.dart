import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/login_signup/form_divider.dart';
import 'package:fvapp/common/widgets/login_signup/social_buttons.dart';
import 'package:fvapp/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                FVText.signUpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Form
              const FVSignupForm(),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Divider
              FVFormDivider(dividerText: FVText.orSignUpWith.capitalize!),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Social Buttons
              const FVSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
