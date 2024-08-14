import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/chat_model.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final VoidCallback onDelete;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteDialog(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMe ? FVColors.gold : FVColors.darkGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tampilkan gambar paket jika ada
                if (message.packageImageUrl != null && message.packageImageUrl!.isNotEmpty)
                  GestureDetector(
                    onTap: () => _showImageDialog(context, message.packageImageUrl!),
                    child: Image.network(
                      message.packageImageUrl!,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                // Tampilkan nama paket jika ada
                if (message.packageName != null && message.packageName!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      message.packageName!,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Tampilkan kategori paket jika ada
                if (message.categoryName != null && message.categoryName!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Kategori: ${message.categoryName}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                // Tampilkan teks pesan
                if (message.text.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                // Tampilkan file jika ada
                if (message.fileUrl != null && message.fileUrl!.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file, color: Colors.white),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            message.fileName ?? '',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.download_rounded, color: Colors.white),
                          onPressed: () => _openFile(message.fileUrl!),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 4.0),
                Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Text(
                    formatTimestamp(message.timestamp),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Pesan'),
        content: Text('Apakah Anda yakin ingin menghapus pesan ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text('Hapus'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(imageUrl),
      ),
    );
  }

  void _openFile(String fileUrl) async {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Unknown Time';
    }
    var date = timestamp.toDate();
    return DateFormat('HH:mm').format(date);
  }
}
