import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class MessageInput extends StatefulWidget {
  final String roomId;
  final String currentUserId;

  const MessageInput({Key? key, required this.roomId, required this.currentUserId}) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void _sendMessage(String messageText, {String? fileUrl, String? fileName, String? imageUrl}) {
    if (messageText.isEmpty && fileUrl == null && imageUrl == null) {
      return;
    }

    DatabaseReference messageRef = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(widget.roomId)
        .push();

    var message = {
      'senderId': widget.currentUserId,
      'text': messageText,
      'fileUrl': fileUrl ?? '', // URL file diunggah
      'fileName': fileName ?? '', // Nama file
      'imageUrl': imageUrl ?? '', // URL gambar diunggah
      'timestamp': ServerValue.timestamp,
    };

    messageRef.set(message);

    _messageController.clear();
  }

  Future<void> _sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Ekstensi file yang diizinkan
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      Reference storageRef = FirebaseStorage.instance.ref().child('files').child(fileName);

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String fileUrl = await snapshot.ref.getDownloadURL();

      _sendMessage('', fileUrl: fileUrl, fileName: fileName);
    }
  }

  Future<void> _sendImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = pickedFile.path.split('/').last;

      Reference storageRef = FirebaseStorage.instance.ref().child('images').child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();

      _sendMessage('', imageUrl: imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Iconsax.attach_circle),
                      onPressed: _sendFile,
                    ),
                    IconButton(
                      icon: Icon(Iconsax.camera),
                      onPressed: _sendImage,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Iconsax.send_14),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
}
