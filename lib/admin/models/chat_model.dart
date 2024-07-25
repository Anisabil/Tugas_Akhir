import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String imageUrl;
  final String fileUrl;
  final String fileName;
  final String packageId;
  final String packageName;
  final String packageImageUrl;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.imageUrl,
    required this.fileUrl,
    required this.fileName,
    required this.packageId,
    required this.packageName,
    required this.packageImageUrl,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      timestamp: data['timestamp'] as Timestamp,
      imageUrl: data['imageUrl'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      fileName: data['fileName'] ?? '',
      packageId: data['packageId'] ?? '',
      packageName: data['packageName'] ?? '',
      packageImageUrl: data['packageImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'fileName': fileName,
    };
  }
}
