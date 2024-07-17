import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fvapp/admin/controllers/promo_controller.dart';
import 'package:fvapp/admin/models/promo_model.dart';
import 'package:get/get.dart';

class PromoForm extends StatefulWidget {
  final PromoImage? promoImage; // Tambahkan parameter ini

  const PromoForm({Key? key, this.promoImage}) : super(key: key);

  @override
  _PromoFormState createState() => _PromoFormState();
}

class _PromoFormState extends State<PromoForm> {
  final PromoController promoController = Get.find<PromoController>();
  List<File> _imageFiles = [];
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.promoImage != null) {
      isEdit = true;
      // Jika mengedit, tambahkan gambar yang ada ke dalam _imageFiles
      // Misalnya, download gambar dari URL dan simpan sebagai file
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _savePromo() async {
    if (_imageFiles.isEmpty && !isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one image!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      List<String> imageUrls = [];
      if (_imageFiles.isNotEmpty) {
        imageUrls = await _uploadFiles(_imageFiles, 'promos');
      }

      PromoImage promo;
      if (isEdit) {
        promo = PromoImage(
          id: widget.promoImage!.id,
          imageUrl: imageUrls.isEmpty ? widget.promoImage!.imageUrl : imageUrls.first,
        );
        await promoController.updateImage(promo);
      } else {
        promo = PromoImage(
          id: '', // Assuming you do not need to provide ID explicitly
          imageUrl: imageUrls.first,
        );
        await promoController.addImage(promo);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo ${isEdit ? 'updated' : 'added'} successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Navigate back after successful addition or update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to ${isEdit ? 'update' : 'add'} promo: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<List<String>> _uploadFiles(List<File> files, String folder) async {
    List<String> urls = [];

    try {
      for (File file in files) {
        var snapshot = await FirebaseStorage.instance
            .ref('promos/$folder/${file.path.split('/').last}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        urls.add(downloadUrl);
      }
    } catch (e) {
      print('Error uploading files: $e');
      throw Exception('Failed to upload files');
    }

    return urls;
  }

  void _deletePromo() async {
    if (widget.promoImage != null) {
      try {
        await promoController.deleteImage(widget.promoImage!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Promo deleted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete promo: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Promo Image' : 'Add Promo Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _imageFiles.isEmpty
                ? (isEdit && widget.promoImage != null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.promoImage!.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.grey[300],
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('Tidak ada gambar yang dipilih'),
                        ),
                      ))
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.file(
                              _imageFiles[index],
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.camera),
                label: const Text('Pilih Gambar'),
              ),
            ),
            const SizedBox(height: FVSizes.spaceBtwSection * 10),
            Row(
              children: [
                if (isEdit)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _deletePromo,
                      child: const Text('Hapus Promo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _savePromo,
                    child: const Text('Simpan Promo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
