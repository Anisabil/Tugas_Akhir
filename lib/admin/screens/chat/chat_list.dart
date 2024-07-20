import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fvapp/features/studio/chat/chat.dart';

class AdminChatListScreen extends StatelessWidget {
  const AdminChatListScreen({Key? key}) : super(key: key);

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
        title: Text('Daftar Chat Klien'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
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
              child: Text('Tidak ada chat yang ditemukan.'),
            );
          }

          List<DocumentSnapshot> rooms = snapshot.data!.docs;
          print('Rooms found: ${rooms.length}'); // Tambahkan log untuk memeriksa jumlah room yang ditemukan

          List<DocumentSnapshot> filteredRooms = [];
          for (var room in rooms) {
            List<dynamic> userIds = room['userIds'];
            print('Room ID: ${room.id}, User IDs: $userIds'); // Tambahkan log untuk memeriksa User IDs

            // Memeriksa apakah userIds berisi ID user lain
            if (userIds.contains(user.uid)) {
              filteredRooms.add(room);
            }
          }

          if (filteredRooms.isEmpty) {
            return Center(
              child: Text('Tidak ada chat yang ditemukan.'),
            );
          }

          return ListView.builder(
            itemCount: filteredRooms.length,
            itemBuilder: (context, index) {
              DocumentSnapshot room = filteredRooms[index];
              List<dynamic> userIds = room['userIds'];

              String otherUserId = userIds.firstWhere((id) => id != user.uid, orElse: () => '');
              print('Other User ID: $otherUserId'); // Tambahkan log untuk memeriksa otherUserId

              if (otherUserId.isEmpty) {
                return ListTile(
                  title: Text('User lain tidak ditemukan dalam room ini.'),
                );
              }

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
                    return ListTile(
                      title: Text('User tidak ditemukan'),
                    );
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  String userName = userData['userName'];
                  String profilePicture = userData['profilePicture'] ?? '';

                  print('User Data: $userData'); // Tambahkan log untuk memeriksa data pengguna

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePicture),
                    ),
                    title: Text(userName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(receiverId: otherUserId),
                        ),
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
