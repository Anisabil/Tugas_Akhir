import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/screens/chat/room_chat.dart';
import 'package:get/get.dart';

class AdminChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;

    // Debugging: print currentUserId
    print('Current user ID: $currentUserId');

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Chat'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.reference().child('chat_rooms').onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('Tidak ada pesan'));
          }

          Map<dynamic, dynamic> chatRoomsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          var chatRooms = chatRoomsMap.entries.map((entry) {
            var roomId = entry.key;
            var roomData = entry.value;
            return {'roomId': roomId, 'lastMessage': roomData['lastMessage'], 'timestamp': roomData['timestamp']};
          }).toList();

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var room = chatRooms[index];
              var roomId = room['roomId'];
              var userIds = roomId.split('_');
              var otherUserId = userIds.firstWhere((id) => id != currentUserId && id != 'admin', orElse: () => '');

              // Debugging: print otherUserId
              print('otherUserId: $otherUserId');

              // Filter out cases where otherUserId is empty
              if (otherUserId.isEmpty) {
                return SizedBox.shrink(); // Skip rendering this ListTile
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  } else if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${userSnapshot.error}'),
                    );
                  } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    // Debugging: print error message
                    print('User data not found for userId: $otherUserId');
                    return ListTile(
                      title: Text('Unknown User'),
                    );
                  } else {
                    var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    var userRole = userData['role'];

                    // Debugging: print userData and userRole
                    print('userData: $userData');
                    print('userRole: $userRole');

                    return ListTile(
                      title: Text('${userData['userName']} (${userRole})'),
                      subtitle: Text('${room['lastMessage']}'),
                      onTap: () {
                        Get.to(() => AdminChatScreen(roomId: roomId));
                      },
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
