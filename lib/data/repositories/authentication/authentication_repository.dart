import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fvapp/data/repositories/user/user_repository.dart';
import 'package:fvapp/features/authentication/screens/signup/verify_email.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Function to show Relevant screen
  Future<void> screenRedirect() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        if (currentUser.emailVerified) {
          final user = await getUserById(currentUser.uid);
          if (user != null) {
            if (user.role == 'admin') {
              Get.offAll(() => const HomeAdmin());
            } else {
              Get.offAll(() => const NavigationMenu());
            }
          }
          // Panggil fetchUserData di sini setelah pengguna berhasil login
          await UserController.instance.fetchUserData();
        } else {
          Get.offAll(() => VerifyEmailScreen(email: currentUser.email));
        }
      } else {
        deviceStorage.writeIfNull('IsFirstTime', true);
        if (deviceStorage.read('IsFirstTime') != true) {
          Get.offAll(() => const LoginScreen());
        } else {
          Get.offAll(() => const OnBoardingScreen());
        }
      }
    } catch (e) {
      print('Error determining initial route: $e');
      // Redirect to login screen in case of any error
      Get.offAll(() => const LoginScreen());
    }
  }

  // Function to retrieve user data by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final snapshot = await _firestore.collection('Users').doc(userId).get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        return UserModel(
          id: userId,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          userName: data['userName'] ?? '',
          email: data['email'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          profilePicture: data['profilePicture'] ?? '',
          role: data['role'] ?? 'client',
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
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

  // [EmailAuthentication] - FORGET PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a Credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
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

  /*---------------------------- Federated identity & social sign-in -------------------------------*/

  // [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In');

      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      print('User account: $userAccount');

      if (userAccount == null) {
        print('Google Sign-In was cancelled by the user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;
      print('Google authentication: $googleAuth');

      if (googleAuth == null) {
        print('Failed to retrieve Google authentication details');
        return null;
      }

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print('Google credentials: $credentials');

      // Once signed in, return the UserCredentials
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      throw FVFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw FVFirebaseException(e.code).message;
    } on FormatException catch (e) {
      print('FormatException: ${e.message}');
      throw const FVFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw FVPlatformException(e.code).message;
    } catch (e) {
      print('General Exception: $e');
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
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
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
}
