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
      'timestamp': FieldValue.serverTimestamp(), // Pastikan ini ada
      'isRead': false, // Menambahkan flag untuk status baca
    });
  }

  Future<void> sendPackageDetailsToChat(String chatRoomId, String userId, Package package) async {
  await _firestore.collection('rooms').doc(chatRoomId).collection('messages').add({
    'senderId': userId,
    'text': 'Tanya paket ini:',
    'packageId': package.id,
    'packageName': package.name,
    'packageImageUrl': package.imageUrls.isNotEmpty ? package.imageUrls[0] : '',
    'categoryName': package.categoryName, // Pastikan ini disesuaikan dengan data yang Anda miliki
    'timestamp': FieldValue.serverTimestamp(),
    'isRead': false,
  });
}


  /// Mengambil data pengguna
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

  /// Mengambil jumlah pesan baru untuk pengguna
  Future<int> getNewMessagesCount(String roomId) async {
    String userId = _auth.currentUser!.uid;

    // Mengambil pesan yang belum dibaca
    QuerySnapshot messagesSnapshot = await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: userId)
        .get();

    return messagesSnapshot.size;
  }

  /// Mengatur status baca pesan
  Future<void> markMessagesAsRead(String roomId) async {
    String userId = _auth.currentUser!.uid;

    // Mengupdate status baca pesan
    await _firestore.collection('rooms').doc(roomId).collection('messages').where('senderId', isNotEqualTo: userId).where('isRead', isEqualTo: false).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.update({'isRead': true});
      }
    });
  }
}
