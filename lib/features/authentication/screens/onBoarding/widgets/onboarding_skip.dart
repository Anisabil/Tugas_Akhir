import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/controllers/onboarding/onboarding_controller.dart';

import '../../../../../utils/constants/device_utility.dart';
import '../../../../../utils/constants/sizes.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: FVDeviceUtils.getAppBarHeight(),
        right: FVSizes.defaultSpace,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text('Skip'),
        ));
  }
}
