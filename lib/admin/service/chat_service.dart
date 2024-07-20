import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ambil chat list untuk admin
  Future<List<Message>> getAdminChatList(String adminId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Chats')
          .where('receiverId', isEqualTo: adminId)
          .orderBy('timestamp', descending: true)
          .get();

      List<Message> chatList = snapshot.docs.map((doc) {
        return Message.fromFirestore(doc);
      }).toList();

      return chatList;
    } catch (e) {
      print('Error getting admin chat list: $e');
      return [];
    }
  }
}
