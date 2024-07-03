class Message {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final int timestamp;
  final String imageUrl; // Atribut untuk URL gambar
  final String fileUrl; // Atribut untuk URL file
  final String fileName; // Atribut untuk nama file

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.imageUrl,
    required this.fileUrl,
    required this.fileName,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: map['timestamp'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      fileUrl: map['fileUrl'] ?? '', // Inisialisasi atribut fileUrl
      fileName: map['fileName'] ?? '', // Inisialisasi atribut fileName
    );
  }
}
