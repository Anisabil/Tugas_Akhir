import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/chat_model.dart';
import 'package:fvapp/features/studio/chat/screen/bubble_chat.dart';
import 'package:fvapp/features/studio/chat/screen/message_input.dart';
import 'package:fvapp/utils/constants/colors.dart';

class AdminChatScreen extends StatelessWidget {
  final String roomId;

  const AdminChatScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Klien'),
        backgroundColor: FVColors.gold,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(roomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Tidak ada pesan'));
                }

                final messages = snapshot.data!.docs.map((doc) {
                  return Message.fromFirestore(doc);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;
                    return ChatBubble(
                      message: message,
                      isMe: isMe,
                      onDelete: () {
                        _deleteMessage(message.id); // Hapus pesan saat callback dipanggil
                      },
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(roomId: roomId, currentUserId: currentUserId),
        ],
      ),
    );
  }

void _deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .delete();
      print('Message deleted');
    } catch (e) {
      print('Failed to delete message: $e');
    }
  }
}
