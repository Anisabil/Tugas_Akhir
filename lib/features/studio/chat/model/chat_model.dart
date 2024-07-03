class Message {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final int timestamp;
  final String imageUrl; // Tambahkan atribut imageUrl

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.imageUrl, // Inisialisasi atribut imageUrl
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: map['timestamp'] ?? 0,
      imageUrl: map['imageUrl'] ?? '', // Ambil nilai imageUrl dari map
    );
  }
}
