import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fvapp/data/repositories/user/user_repository.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save userrecord from any registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // Convert name to First and Last name
        final nameParts =
            UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final username =
            UserModel.generateUsername(userCredentials.user!.displayName ?? '');
        
        // Panggil fungsi determineUserRole untuk menentukan peran pengguna
        final role = await determineUserRole(userCredentials.user!);

        // Map data
        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join('') : '',
          username: username,
          email: userCredentials.user!.email ?? '',
          phoneNumber: userCredentials.user!.phoneNumber ?? '',
          profilePicture: userCredentials.user!.photoURL ?? '',
          role: role,
        );

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      FVLoaders.warningSnackBar(
        title: 'Data tidak tersimpan',
        message:
            'Ada kesalahan saat meyimpan informasi Anda. Anda dapat menyimpan data Anda lagi di profil Anda',
      );
    }
  }

  // Fungsi untuk menentukan peran pengguna berdasarkan data di Firestore
  Future<String> determineUserRole(User user) async {
    try {
      // Ambil ID pengguna yang saat ini login
      String userId = user.uid;
      
      // Query Firestore untuk mendapatkan dokumen pengguna berdasarkan ID
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(userId).get();
      
      // Periksa apakah dokumen pengguna ada dan memiliki bidang 'role'
      if (userDoc.exists && userDoc.data()!.containsKey('role')) {
        // Ambil nilai peran dari dokumen pengguna
        String role = userDoc.data()!['role'];
        
        // Periksa apakah peran adalah 'admin' atau 'client'
        if (role == 'admin' || role == 'client') {
          // Jika peran adalah 'admin' atau 'client', kembalikan nilai peran
          return role;
        } else {
          // Jika peran tidak sesuai, kembalikan 'client' sebagai nilai default
          return 'client';
        }
      } else {
        // Jika dokumen pengguna tidak ditemukan atau tidak memiliki bidang 'role', kembalikan 'client' sebagai nilai default
        return 'client';
      }
    } catch (e) {
      // Tangani kesalahan jika terjadi
      print('Error determining user role: $e');
      // Kembalikan 'client' sebagai nilai default jika terjadi kesalahan
      return 'client';
    }
  }
}
