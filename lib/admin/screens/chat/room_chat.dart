import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ganti import

import 'package:fvapp/features/studio/chat/model/chat_model.dart';
import 'package:fvapp/features/studio/chat/screen/message_input.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminChatScreen extends StatelessWidget {
  final String roomId;

  const AdminChatScreen({Key? key, required this.roomId}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan Klien'),
      ),
      body: Column(
        children: [
          Expanded(child: AdminMessageList(roomId: roomId, currentUserId: user.uid)),
          MessageInput(roomId: roomId, currentUserId: user.uid),
        ],
      ),
    );
  }
}

class AdminMessageList extends StatelessWidget {
  final String roomId;
  final String currentUserId;

  const AdminMessageList({Key? key, required this.roomId, required this.currentUserId}) : super(key: key);

  String formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: false) // Sesuaikan dengan field timestamp Anda
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

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Tidak ada pesan'),
          );
        }

        List<Message> messages = snapshot.data!.docs.map((doc) => Message.fromFirestore(doc)).toList();

        // Sort messages by timestamp in ascending order (oldest first)
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            bool isAdmin = message.senderId == currentUserId; // Assuming `senderId` is a field in Message model
            bool hasImage = message.imageUrl.isNotEmpty; // Check if message has imageUrl
            bool hasFile = message.fileUrl.isNotEmpty; // Check if message has fileUrl

            return Align(
              alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
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
                  } else if (hasFile) {
                    // Open file URL
                    _launchURL(message.fileUrl);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isAdmin ? FVColors.gold : FVColors.grey,
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Image.network(
                            message.imageUrl,
                            height: 150, // Adjust size as needed
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (hasFile) // Show file if available
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _launchURL(message.fileUrl);
                              },
                              icon: Icon(Iconsax.attach_circle),
                              label: Flexible(
                                child: Text(
                                  message.fileName,
                                  style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis, // Prevent overflow
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 5),
                      Text(
                        formatTimestamp(message.timestamp),
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12),
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
