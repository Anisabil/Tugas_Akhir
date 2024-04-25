import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fvapp/common/widgets/success_screen/success_screen.dart';
import 'package:fvapp/data/repositories/authentication/authentication_repository.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:get/get.dart';

import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  // Send email whenever verify screen appears and set time for auto redirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  // Send email verification link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      FVLoaders.successSnackBar(
          title: 'Email Terkirim',
          message:
              'Silahkan periksa kotak masuk Anda dan verifikasi email Anda');
    } catch (e) {
      FVLoaders.errorSnackBar(title: 'Cepat!', message: e.toString());
    }
  }

  // Timer to automatically redirect on email verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
            image: FVImages.redirectEmailIlustration,
            title: FVText.yourAccountCreatedTitle,
            subTitle: FVText.yourAccountCreatedSubTitle,
            onPressed: () =>AuthenticationRepository.instance.screenRedirect()
          ),
        );
      }
    });
  }

  // Manually check in email verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: FVImages.successIlustration,
          title: FVText.yourAccountCreatedTitle,
          subTitle: FVText.yourAccountCreatedSubTitle,
          onPressed: () =>AuthenticationRepository.instance.screenRedirect()
        ),
      );
    }
  }
}
