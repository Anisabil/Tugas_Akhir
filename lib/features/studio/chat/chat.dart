import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fvapp/admin/models/chat_model.dart';
import 'package:fvapp/features/studio/chat/screen/message_input.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate(); // Konversi Timestamp ke DateTime
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Tidak ada pesan'),
          );
        }

        List<Message> messages = snapshot.data!.docs.map((doc) {
          return Message.fromFirestore(doc);
        }).toList();

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            bool isClient = message.senderId == currentUserId;
            bool hasImage = message.imageUrl.isNotEmpty;
            bool hasFile = message.fileUrl.isNotEmpty;

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
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  } else if (hasFile) {
                    _launchURL(message.fileUrl);
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
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      if (hasImage)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Image.network(
                            message.imageUrl,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (hasFile)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FVColors.grey,
                                side: BorderSide(color: FVColors.grey),
                              ),
                              onPressed: () {
                                _launchURL(message.fileUrl);
                              },
                              icon: Icon(Iconsax.attach_circle, color: Colors.black),
                              label: Flexible(
                                child: Text(
                                  message.fileName,
                                  style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
