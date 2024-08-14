import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/chat/room_chat.dart';
import 'package:fvapp/utils/constants/colors.dart';

class AdminChatListScreen extends StatelessWidget {
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String roomId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus chat ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('rooms')
                      .doc(roomId)
                      .delete();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error deleting chat: ${e.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting chat: ${e.toString()}')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getClientName(String roomId) async {
    try {
      // Ambil dokumen room untuk mendapatkan clientId
      var roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
      if (roomDoc.exists) {
        var roomData = roomDoc.data();
        var clientId = roomData?['clientId']; // Pastikan field ini ada di dokumen `rooms`

        if (clientId != null) {
          // Ambil nama klien berdasarkan clientId dari koleksi `Users`
          var userDoc = await FirebaseFirestore.instance.collection('Users').doc(clientId).get();
          if (userDoc.exists) {
            var userData = userDoc.data();
            print('User data: ${userData}'); // Debugging
            return userData?['userName'] ?? 'Unknown'; // Ganti 'userName' dengan field yang sesuai
          } else {
            print('User document does not exist for ID: $clientId');
          }
        } else {
          print('Client ID is null for room ID: $roomId');
        }
      } else {
        print('Room document does not exist for ID: $roomId');
      }
    } catch (e) {
      print('Error fetching client name: ${e.toString()}');
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Chat Client'),
        backgroundColor: FVColors.gold,
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
              return FutureBuilder<String>(
                future: _getClientName(room.id),
                builder: (context, clientNameSnapshot) {
                  if (!clientNameSnapshot.hasData) {
                    return ListTile(
                      title: Text('Loading...'),
                      subtitle: Text('Loading...'),
                    );
                  }

                  var clientName = clientNameSnapshot.data!;
                  return GestureDetector(
                    onLongPress: () {
                      _showDeleteConfirmationDialog(context, room.id);
                    },
                    child: ListTile(
                      title: Text(clientName),
                      subtitle: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(room.id)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, messageSnapshot) {
                          if (!messageSnapshot.hasData ||
                              messageSnapshot.data!.docs.isEmpty) {
                            return Text('No messages');
                          }
                          var lastMessage = messageSnapshot.data!.docs.first;
                          var messageText = lastMessage['text'] ?? 'No text';
                          return Text('Pesan terakhir: $messageText');
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminChatScreen(roomId: room.id),
                          ),
                        );
                      },
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
