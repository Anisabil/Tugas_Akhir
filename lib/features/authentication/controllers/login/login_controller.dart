import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/popups/full_screen_loader.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController {
  // variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
      email.text = localStorage.read('REMEMBER_ME_EMAIL');
      password.text = localStorage.read('REMEMBER_ME_PASSWORD');
    super.onInit();
  }

  // Email and password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start loading
      FVFullScreenLoader.openLoadingDialog(
          'Masuk...', FVImages.loadingIlustration);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using Email & Password Authentication
      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove loader
      FVFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FVFullScreenLoader.stopLoading();
      FVLoaders.errorSnackBar(title: 'Cepat!', message: e.toString());
    }
  }

  // Google SignIn Authentication
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      FVFullScreenLoader.openLoadingDialog(
          'Masuk...', FVImages.loadingIlustration);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      // Google Authentication
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User membatalkan sign-in
        FVFullScreenLoader.stopLoading();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase dengan credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Simpan rekaman pengguna
      await userController.saveUserRecord(userCredential);

      // Remove loader
      FVFullScreenLoader.stopLoading();

      // Redirect atau lakukan tindakan yang diperlukan setelah login berhasil
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove loader
      FVFullScreenLoader.stopLoading();
      FVLoaders.errorSnackBar(title: 'Error', message: 'Gagal masuk. Silakan coba lagi.');
    }
  }
}
