import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/chat/room_chat.dart';
import 'package:fvapp/utils/constants/colors.dart';

class AdminChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Chat Client'),
        backgroundColor: FVColors.gold, // Sesuaikan dengan warna tema
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var rooms = snapshot.data!.docs;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              var room = rooms[index];
              return ListTile(
                title: Text('Client ${room.id}'),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rooms')
                      .doc(room.id)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
                      return Text('No messages');
                    }
                    var lastMessage = messageSnapshot.data!.docs.first;
                    return Text('Last message: ${lastMessage['text']}');
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminChatScreen(roomId: room.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
