import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/screens/chat/room_chat.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
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

          var chatRooms = snapshot.data!.docs;

          // Filter hanya chat room yang melibatkan admin
          var adminChatRooms = chatRooms.where((room) {
            var userIds = room.id.split('_');
            // Debugging: print userIds
            print('userIds in room ${room.id}: $userIds');
            return userIds.contains(currentUserId) && userIds.any((id) => id != currentUserId && id == 'client');
          }).toList();

          // Debugging: print adminChatRooms
          print('Admin chat rooms: ${adminChatRooms.map((room) => room.id).toList()}');

          if (adminChatRooms.isEmpty) {
            return Center(child: Text('Tidak ada pesan'));
          }

          return ListView.builder(
            itemCount: adminChatRooms.length,
            itemBuilder: (context, index) {
              var room = adminChatRooms[index];
              var roomId = room.id;

              // Debugging: print roomId
              print('Room ID: $roomId');

              return FutureBuilder<QuerySnapshot>(
                future: room.reference.collection('messages').orderBy('timestamp', descending: true).limit(1).get(),
                builder: (context, messagesSnapshot) {
                  if (messagesSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  if (messagesSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${messagesSnapshot.error}'),
                    );
                  }

                  if (!messagesSnapshot.hasData || messagesSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text('No messages'),
                    );
                  }

                  var lastMessage = messagesSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                  var userIds = roomId.split('_');
                  var otherUserId = userIds.firstWhere((id) => id != currentUserId && id != 'admin', orElse: () => '');

                  // Debugging: print otherUserId
                  print('otherUserId: $otherUserId');

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('Users').doc(otherUserId).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                        );
                      }

                      if (userSnapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${userSnapshot.error}'),
                        );
                      }

                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                        // Debugging: print error message
                        print('User data not found for userId: $otherUserId');
                        return ListTile(
                          title: Text('Unknown User'),
                        );
                      }

                      var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      var userRole = userData['role'];

                      // Debugging: print userData and userRole
                      print('userData: $userData');
                      print('userRole: $userRole');

                      return ListTile(
                        title: Text('${userData['userName']} (${userRole})'),
                        subtitle: Text('${lastMessage['text'] ?? 'No message'}'),
                        onTap: () {
                          Get.to(() => AdminChatScreen(roomId: roomId));
                        },
                      );
                    },
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
