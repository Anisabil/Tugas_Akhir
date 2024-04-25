import 'package:flutter/material.dart';
import 'package:fvapp/data/repositories/authentication/authentication_repository.dart';
import 'package:fvapp/data/repositories/user/user_repository.dart';
import 'package:fvapp/features/authentication/screens/signup/verify_email.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // --- SIGNUP
  void signup() async {
    try {
      // Star loading
      FVFullScreenLoader.openLoadingDialog(
          'Kami sedang memproses informasi Anda...',
          FVImages.processDataIlustration);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Form validation
      if (!signupFormKey.currentState!.validate()) return;

      // Privacy Police Check
      if (!privacyPolicy.value) {
        FVLoaders.warningSnackBar(
          title: 'Menerima kebijakan privasi',
          message:
              'Untuk membuat akun, Anda harus membaca dan menerima kebijakan privasi pengguna',
        );
        return;
      }

      // Register User in the Firebase Authentication & save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save authentication user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
        role: 'client',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Show success message
      FVLoaders.successSnackBar(
          title: 'Selamat',
          message:
              'Akun Anda telah dibuat! Verifikasi email untuk melanjutkan');

      // Move to verify email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // show some generic error to the user
      FVLoaders.errorSnackBar(title: 'Cepat!', message: e.toString());
    } finally {
      // remove loader
      FVFullScreenLoader.stopLoading();
    }
  }
}
