import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/device_utility.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = FVHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: FVDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: FVSizes.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationIndicator,
        effect: ExpandingDotsEffect(
            activeDotColor: dark ? FVColors.light : FVColors.dark,
            dotHeight: 6),
      ),
    );
  }
}
