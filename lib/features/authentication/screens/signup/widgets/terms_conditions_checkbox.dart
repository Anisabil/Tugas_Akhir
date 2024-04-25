import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/controllers/signup/signup_controller.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_function.dart';

class FVTermsAndConditionCheckbox extends StatelessWidget {
  const FVTermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = FVHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value,
            )
          ),
        ),
        const SizedBox(
          width: FVSizes.spaceBtwItems,
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${FVText.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                    text: FVText.privacyPolicy,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark ? FVColors.white : FVColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              dark ? FVColors.white : FVColors.primary,
                        )),
                TextSpan(
                  text: ' ${FVText.and} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                    text: FVText.termsOfUs,
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark ? FVColors.white : FVColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              dark ? FVColors.white : FVColors.primary,
                        )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
