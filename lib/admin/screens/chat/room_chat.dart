import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ganti import

import 'package:fvapp/admin/models/chat_model.dart';
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

  const AdminMessageList({
    Key? key,
    required this.roomId,
    required this.currentUserId,
  }) : super(key: key);

  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('HH:mm').format(timestamp.toDate()); // Hanya gunakan timestamp
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

        List<Message> messages = snapshot.data!.docs
            .map((doc) => Message.fromFirestore(doc))
            .toList();

        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            bool isAdmin = message.senderId == currentUserId;
            bool hasImage = message.imageUrl.isNotEmpty;
            bool hasFile = message.fileUrl.isNotEmpty;

            return Align(
              alignment:
                  isAdmin ? Alignment.centerRight : Alignment.centerLeft,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color:
                        isAdmin ? Colors.blueAccent : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      if (hasImage)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5),
                          child: Image.network(
                            message.imageUrl,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (hasFile)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 200),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _launchURL(message.fileUrl);
                              },
                              icon: Icon(Icons.attach_file),
                              label: Flexible(
                                child: Text(
                                  message.fileName,
                                  style: TextStyle(
                                      color: Colors.black),
                                  overflow:
                                      TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 5),
                      Text(
                        formatTimestamp(message.timestamp),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70),
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