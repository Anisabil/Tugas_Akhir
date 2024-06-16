import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:fvapp/data/repositories/authentication/authentication_repository.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
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

  // Function to Fetch user details based on user ID.
  Future<UserModel> fecthUserDetails() async {
    try {
      final DocumentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if (DocumentSnapshot.exists) {
        return UserModel.fromSnapshot(DocumentSnapshot);
      } else {
        return UserModel.empty();
      }
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

  // Function to Update user data in Firestore.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
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

  // Update uny field in specific users collection.
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
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

  // Function to remove user data from Firestore.
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
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

  // Upload any Image
}
