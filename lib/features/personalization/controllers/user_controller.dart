import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/data/repositories/authentication/authentication_repository.dart';
import 'package:fvapp/data/repositories/user/user_repository.dart';
import 'package:fvapp/features/authentication/screens/login/login.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/network_manager.dart';
import 'package:fvapp/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  var userId = ''.obs;
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void setUserId(String id) {
    userId.value = id;
  }

  Future<void> fecthUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fecthUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      profileLoading.value = true;
      await userRepository.updateUserDetails(updatedUser);
      user.value = updatedUser;

      // Print untuk debugging
      print('User data updated successfully: ${updatedUser.toJson()}');

      FVLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Data pengguna berhasil diperbarui.',
      );
    } catch (e) {
      print('Error updating user data: $e');
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memperbarui data pengguna. Silakan coba lagi.',
      );
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.id)
          .set(user.toJson());
      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<UserModel?> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in!');
      return null;
    } else {
      print('Fetching data for user ID: ${user.uid}');
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

      if (userSnapshot.exists) {
        print('User data: ${userSnapshot.data()}');
        final userData = UserModel.fromSnapshot(userSnapshot);
        this.user.value = userData; // Update the observable user
        return userData;
      } else {
        print('User document does not exist!');
        return null;
      }
    }
  }

  Future<UserModel?> getUserData() async {
    return await fetchUserData();
  }

  // Save user record from any registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        final nameParts =
            UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final userName =
            UserModel.generateuserName(userCredentials.user!.displayName ?? '');

        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          userName: userName,
          email: userCredentials.user!.email ?? '',
          phoneNumber: userCredentials.user!.phoneNumber ?? '',
          profilePicture: userCredentials.user!.photoURL ?? '',
          role: '',
          gender: '',
          birthdate: '',
        );

        // Save user data to Firestore
        await UserController.instance.saveUserData(user);
        print('User data saved: ${user.toJson()}');
      }
    } catch (e) {
      print('Error saving user record: $e');
      FVLoaders.warningSnackBar(
        title: 'Data tidak tersimpan',
        message:
            'Ada kesalahan saat meyimpan informasi Anda. Anda dapat menyimpan data Anda lagi di profil Anda',
      );
    }
  }

  // Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(FVSizes.md),
        title: 'Hapus Akun',
        middleText:
            'Apakah Anda yakin ingin menghapus akun Anda secara permanen? Tindakan ini tidak dapat diterima dan semua data Anda akan dihapus secara permanen.',
        confirm: ElevatedButton(
            onPressed: () async => deleteUserAccount(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red)),
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: FVSizes.lg),
                child: Text('Hapus'))),
        cancel: OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text('Batal')));
  }

  // Delete User Account
  void deleteUserAccount() async {
    try {
      FVFullScreenLoader.openLoadingDialog(
          'Memproses', FVImages.processDataIlustration);

      // First re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re verify auth email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          FVFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          FVFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      FVFullScreenLoader.stopLoading();
      FVLoaders.warningSnackBar(title: 'Gagal!', message: e.toString());
    }
  }

  // Re - AUTHENTICATE before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      FVFullScreenLoader.openLoadingDialog(
          'Memproses', FVImages.processDataIlustration);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        FVFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      FVFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      FVFullScreenLoader.stopLoading();
      FVLoaders.warningSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }

  Future<void> pickAndUploadProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        // Upload to Firebase Storage
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${user.value.id}');
        final UploadTask uploadTask = storageReference.putFile(imageFile);

        final TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() => {});
        final String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Update profile picture URL in Firestore
        final updatedUser = user.value.copyWith(profilePicture: downloadURL);
        await updateUserData(updatedUser);
      }
    } catch (e) {
      print('Error picking or uploading image: $e');
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengunggah foto profil. Silakan coba lagi.',
      );
    }
  }

  Future<UserModel?> fetchAdmin() async {
    // Logic to fetch admin user
    try {
      // Assuming you fetch the admin user by role or another identifier
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'admin')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(querySnapshot.docs.first);
      } else {
        return null; // Return null or handle case when admin not found
      }
    } catch (e) {
      print('Error fetching admin: $e');
      return null; // Handle error case
    }
  }
}
