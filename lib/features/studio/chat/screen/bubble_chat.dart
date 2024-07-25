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

  const ChatBubble({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 4, horizontal: 10), // Jarak vertical
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
              if (message.imageUrl.isNotEmpty)
                GestureDetector(
                  onTap: () => _showImageDialog(context, message.imageUrl),
                  child: Image.network(
                    message.imageUrl,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              if (message.fileUrl.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.7, // Lebar maksimal bubble
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_file, color: Colors.white),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          message.fileName,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.download_rounded, color: Colors.white),
                        onPressed: () => _openFile(message.fileUrl),
                      ),
                    ],
                  ),
                ),
              if (message.text.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width *
                        0.7, // Lebar maksimal bubble
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.white),
                    softWrap: true, // Teks akan dibungkus jika terlalu panjang
                    overflow: TextOverflow.visible, // Teks tidak akan dipotong
                  ),
                ),
              SizedBox(height: 4.0), // Jarak antara text dan timestamp
              Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  formatTimestamp(
                      message.timestamp), // Tampilkan waktu pengiriman
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
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    Get.dialog(
      Dialog(
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
}

String formatTimestamp(Timestamp timestamp) {
  var date = timestamp.toDate();
  return DateFormat('HH:mm').format(date);
}
