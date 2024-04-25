import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/screens/login/widgets/login_form.dart';
import 'package:fvapp/features/authentication/screens/login/widgets/login_header.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: FVSpacingStyle.paddingWidthAppBarHeight,
          child: Column(
            children: [
              // logo
              const FVLoginHeader(),

              // Form
              const FVLoginForm(),

              // Divider
              FVFormDivider(dividerText: FVText.orSignInWith.capitalize!,),
              const SizedBox(
                height: FVSizes.spaceBtwSection,
              ),

              // Footer
              const FVSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}




