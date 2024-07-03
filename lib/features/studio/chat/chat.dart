import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fvapp/features/studio/chat/model/chat_model.dart';
import 'package:fvapp/features/studio/chat/screen/message_input.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;

  const ChatScreen({Key? key, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Anda harus login untuk mengakses fitur ini.'),
        ),
      );
    }

    String roomId = user.uid.compareTo(receiverId) > 0 ? "${user.uid}_$receiverId" : "${receiverId}_${user.uid}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan Admin'),
      ),
      body: Column(
        children: [
          Expanded(child: MessageList(roomId: roomId, currentUserId: user.uid)),
          MessageInput(roomId: roomId, currentUserId: user.uid),
        ],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final String roomId;
  final String currentUserId;

  const MessageList({Key? key, required this.roomId, required this.currentUserId}) : super(key: key);

  String formatTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .reference()
          .child('messages')
          .child(roomId)
          .orderByChild('timestamp')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return Center(
            child: Text('Tidak ada pesan'),
          );
        }

        List<Message> messages = [];
        Map<dynamic, dynamic>? data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              try {
                Map<String, dynamic> messageMap = value.map((key, value) => MapEntry(key.toString(), value));
                messages.add(Message.fromMap(messageMap));
              } catch (e) {
                print('Error parsing message: $e');
              }
            }
          });
        }

        if (messages.isEmpty) {
          return Center(
            child: Text('Tidak ada pesan'),
          );
        }

        // Sort messages by timestamp in descending order
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView.builder(
          reverse: true, // Show latest message at the bottom
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            bool isClient = message.senderId == currentUserId; // Assuming `senderId` is a field in Message model
            bool hasImage = message.imageUrl.isNotEmpty; // Check if message has imageUrl

            return Align(
              alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  if (hasImage) {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Image.network(
                          message.imageUrl,
                          fit: BoxFit.contain, // Adjust image fit as needed
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isClient ? FVColors.gold : FVColors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.text.isNotEmpty) // Show text message if available
                        Text(
                          message.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      if (hasImage) // Show image if available
                        Image.network(
                          message.imageUrl,
                          height: 150, // Adjust size as needed
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 5),
                      Text(
                        formatTimestamp(message.timestamp),
                        style: TextStyle(color: Colors.black54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
