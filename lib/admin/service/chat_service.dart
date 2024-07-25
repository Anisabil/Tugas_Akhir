import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fvapp/admin/models/package_model.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Mendapatkan atau membuat chat room ID antara client dan admin
  Future<String> getOrCreateChatRoomId(String adminId) async {
    String userId = _auth.currentUser!.uid;

    // Menggunakan ID client dan admin untuk menentukan chat room
    String chatRoomId = userId.compareTo(adminId) < 0
        ? '$userId-$adminId'
        : '$adminId-$userId';

    // Cek apakah chat room sudah ada
    DocumentSnapshot chatRoomDoc = await _firestore
        .collection('rooms')
        .doc(chatRoomId)
        .get();

    if (!chatRoomDoc.exists) {
      // Jika chat room tidak ada, buat dokumen chat room baru
      await _firestore.collection('rooms').doc(chatRoomId).set({
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  /// Mengirim pesan ke chat room
  Future<void> sendMessage(String roomId, String senderId, String messageText, {String? fileUrl, String? fileName, String? imageUrl}) async {
    if (messageText.isEmpty && fileUrl == null && imageUrl == null) {
      return;
    }

    await _firestore.collection('rooms')
        .doc(roomId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'text': messageText,
      'fileUrl': fileUrl ?? '',
      'fileName': fileName ?? '',
      'imageUrl': imageUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendPackageDetailsToChat(String chatRoomId, String userId, Package package) async {
    // Menyimpan detail paket ke Firestore sebagai pesan
    await FirebaseFirestore.instance.collection('rooms').doc(chatRoomId).collection('messages').add({
      'senderId': userId,
      'text': 'Paket yang Anda pilih:',
      'packageId': package.id,
      'packageName': package.name,
      'packageImageUrl': package.imageUrls.isNotEmpty ? package.imageUrls[0] : '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      var userDoc = await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}
