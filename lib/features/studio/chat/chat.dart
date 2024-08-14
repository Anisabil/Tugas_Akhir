import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/chat_model.dart';
import 'package:fvapp/admin/service/chat_service.dart';
import 'package:fvapp/features/studio/chat/screen/bubble_chat.dart';
import 'package:fvapp/features/studio/chat/screen/message_input.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  final String currentUserId;

  ChatScreen({required this.roomId, required this.currentUserId});

  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = Get.find<ChatService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
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
        .orderBy('timestamp')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      final messages = snapshot.data?.docs.map((doc) {
        final message = Message.fromFirestore(doc);
        return message;
      }).toList() ?? [];

      return ListView.builder(
        controller: _scrollController,
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
