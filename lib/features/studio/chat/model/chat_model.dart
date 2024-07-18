import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final Timestamp timestamp; // Gunakan Timestamp, bukan DateTime
  final String imageUrl;
  final String fileUrl;
  final String fileName;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.imageUrl,
    required this.fileUrl,
    required this.fileName,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(), // Sesuaikan dengan cara menyimpan timestamp di Firestore
      imageUrl: data['imageUrl'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      fileName: data['fileName'] ?? '',
    );
  }
}
