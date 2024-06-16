import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class EditPackagePage extends StatefulWidget {
  final String packageId;
  final String packageName;
  final List<File> imageFiles;
  final List<String> imageUrls;
  final int price;
  final String description;
  final List<String> categories;
  final String selectedCategory;

  const EditPackagePage({
    Key? key,
    required this.packageId,
    required this.packageName,
    required this.imageFiles,
    required this.imageUrls,
    required this.price,
    required this.description,
    required this.categories,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  _EditPackagePageState createState() => _EditPackagePageState();
}

class _EditPackagePageState extends State<EditPackagePage> {
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _imageFiles = [];
  List<String> _imageUrls = [];
  String? _selectedCategory;

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _packageNameController.text = widget.packageName;
    _priceController.text = widget.price.toString();
    _descriptionController.text = widget.description;
    _selectedCategory = widget.selectedCategory;
    _imageFiles = widget.imageFiles;
    _imageUrls = widget.imageUrls;
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _imageFiles.length) {
        _imageFiles.removeAt(index);
      } else {
        _imageUrls.removeAt(index - _imageFiles.length);
      }
    });
  }

  void _deletePackage() async {
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Yakin paket ini dihapus?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      try {
        await _databaseReference.child('packages/${widget.packageId}').remove();
        Navigator.of(context).pop();
        FVLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Paket berhasil dihapus.',
        );
      } catch (e) {
        print('Error occurred while deleting package: $e');
        FVLoaders.errorSnackBar(
          title: 'Error',
          message: 'Terjadi kesalahan saat menghapus paket.',
        );
      }
    }
  }

  Future<void> _updatePackage() async {
    if (_packageNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null) {
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Semua field harus diisi.',
      );
      return;
    }

    try {
      List<String> imageUrls = _imageUrls;
      for (File imageFile in _imageFiles) {
        String? imageUrl = await _uploadImage(imageFile, widget.packageId);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      await _databaseReference.child('packages/${widget.packageId}').update({
        'name': _packageNameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'categoryId': _selectedCategory,
        'imageUrls': imageUrls,
      });

      Navigator.of(context).pop();
      FVLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Paket berhasil diupdate.',
      );
    } catch (e) {
      print('Error occurred while updating package: $e');
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan saat mengupdate paket.',
      );
    }
  }

  Future<String?> _uploadImage(File imageFile, String packageId) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('packages/$packageId/${imageFile.path.split('/').last}')
          .putFile(imageFile);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Paket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageFiles.isEmpty && _imageUrls.isEmpty
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('Tidak ada gambar yang dipilih'),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageFiles.length + _imageUrls.length,
                        itemBuilder: (context, index) {
                          if (index < _imageFiles.length) {
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
                          } else {
                            int urlIndex = index - _imageFiles.length;
                            return Stack(
                              children: [
                                Image.network(
                                  _imageUrls[urlIndex],
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Text('Gambar tidak tersedia'),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.cancel, color: FVColors.gold),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _packageNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Paket',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Paket',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Kategori Paket',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Paket',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updatePackage,
                      child: const Text('Simpan'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (widget.packageName.isNotEmpty)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _deletePackage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Hapus'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
