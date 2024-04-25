import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fvapp/features/authentication/screens/signup/verify_email.dart';
import 'package:fvapp/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../admin/screens/home_admin.dart';
import '../../../features/authentication/screens/login/login.dart';
import '../../../features/authentication/screens/onBoarding/onboarding.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/popups/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final firebaseApp = Firebase.app();
  final ref = FirebaseDatabase.instance.ref();

  // Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      // Mendapatkan dokumen pengguna dari Firestore berdasarkan ID
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      final snapshot = await ref.child('User/$userId').get();

      // Memeriksa apakah dokumen pengguna ada
      if (snapshot.exists) {
        // Mengonversi dokumen menjadi objek UserModel menggunakan factory method
        return UserModel.fromSnapshot(userDoc);
      } else {
        // Mengembalikan null jika dokumen tidak ada
        return null;
      }
    } catch (e) {
      // Menangani kesalahan jika terjadi
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Function to show Relevant screen
  void screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      // Cek apakah email pengguna sudah diverifikasi
      if (user.emailVerified) {
        // Dapatkan data pengguna dari Firestore
        final userData =
            await AuthenticationRepository.instance.getUserById(user.uid);
        final snapshot = await ref.child('User/${user.uid}').get();
        if (snapshot.exists) {
          switch (snapshot.child("Role").value) {
            case 'admin':
              // Redirect ke halaman admin
              Get.offAll(() => const HomeAdmin());

              break;
            case 'client':
              // Redirect ke halaman client
              Get.offAll(() => const NavigationMenu());

              break;
            default:
              // Handle kasus ketika peran tidak ditemukan
              FVLoaders.errorSnackBar(
                  title: 'Error!', message: 'Peran pengguna tidak valid');
          }
        } else {
          // Handle kasus ketika data pengguna tidak ditemukan
          FVLoaders.errorSnackBar(
              title: 'Error!', message: 'Data pengguna tidak ditemukan');
        }
      } else {
        // Redirect ke halaman verifikasi email jika email belum diverifikasi
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      // Jika pengguna tidak login, redirect ke halaman masuk atau onboarding
      deviceStorage.writeIfNull('IsFirstTime', true);
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }

  /*---------------------------- Email & Password sign-in -------------------------------*/

  // [Email Authentication] - LOGIN
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw FVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FVFormatException();
    } on PlatformException catch (e) {
      throw FVPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada kesalahan. Silahkan coba lagi';
    }
  }

  // [Email Authentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw FVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FVFormatException();
    } on PlatformException catch (e) {
      throw FVPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada kesalahan. Silahkan coba lagi';
    }
  }

  // [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw FVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FVFormatException();
    } on PlatformException catch (e) {
      throw FVPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada kesalahan. Silahkan coba lagi';
    }
  }

  // [ReAuthenticate] - ReAuthenticate User

  // [EmailAuthentication] - FORGET PASSWORD

  /*---------------------------- Federated identity & social sign-in -------------------------------*/

  // [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredentials
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      throw FVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw FVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FVFormatException();
    } on PlatformException catch (e) {
      throw FVPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Ada yang salah: $e');
      return null;
    }
  }

  // [FacebookAuthentication] - FACEBOOK

  /*---------------------------- ./end Federated identity & social sign-in -------------------------------*/

  // [LogoutUser] - Valid for any authentication
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw FVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw FVFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FVFormatException();
    } on PlatformException catch (e) {
      throw FVPlatformException(e.code).message;
    } catch (e) {
      throw 'Ada kesalahan. Silahkan coba lagi';
    }
  }

  // DELETE USER - Remove user Auth and Firestore Account
}
