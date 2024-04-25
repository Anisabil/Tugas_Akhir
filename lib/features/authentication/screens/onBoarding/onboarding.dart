import 'package:flutter/material.dart';
import 'package:fvapp/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:fvapp/features/authentication/screens/onBoarding/widgets/onboarding_dot_navigation.dart';
import 'package:fvapp/features/authentication/screens/onBoarding/widgets/onboarding_next_button.dart';
import 'package:fvapp/features/authentication/screens/onBoarding/widgets/onboarding_page.dart';
import 'package:fvapp/features/authentication/screens/onBoarding/widgets/onboarding_skip.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: FVImages.onBoardingImage1,
                title: FVText.onBoardingTitle1,
                subTitle: FVText.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: FVImages.onBoardingImage2,
                title: FVText.onBoardingTitle2,
                subTitle: FVText.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: FVImages.onBoardingImage3,
                title: FVText.onBoardingTitle3,
                subTitle: FVText.onBoardingSubTitle3,
              ),
            ],
          ),
          // Skip Button
          const OnBoardingSkip(),

          // Dot Navidation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          // Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
