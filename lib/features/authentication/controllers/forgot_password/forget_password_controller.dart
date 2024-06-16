import 'package:flutter/material.dart';
import 'package:fvapp/data/repositories/authentication/authentication_repository.dart';
import 'package:fvapp/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/helpers/network_manager.dart';
import 'package:fvapp/utils/popups/full_screen_loader.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  // variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  // Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      FVFullScreenLoader.openLoadingDialog(
          'Memproses Permintaan Anda...', FVImages.processDataIlustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      FVFullScreenLoader.stopLoading();

      // Show Success Screen
      FVLoaders.successSnackBar(
          title: 'Email Terkirim',
          message:
              'Tautan email terkirim untuk mengatur ulang kata sandi Anda'.tr);

      // Redirect
      Get.to(() => ResetPassword(email: email.text.trim()));

    } catch (e) {
      // Remove Loader
      FVFullScreenLoader.stopLoading();
      FVLoaders.errorSnackBar(title: 'Oh Tidak', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      FVFullScreenLoader.openLoadingDialog(
          'Memproses Permintaan Anda...', FVImages.processDataIlustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email);

      // Remove Loader
      FVFullScreenLoader.stopLoading();

      // Show Success Screen
      FVLoaders.successSnackBar(
          title: 'Email Terkirim',
          message:
              'Tautan email terkirim untuk mengatur ulang kata sandi Anda'.tr);

    } catch (e) {
      // Remove Loader
      FVFullScreenLoader.stopLoading();
      FVLoaders.errorSnackBar(title: 'Oh Tidak', message: e.toString());
    }
  }
}
