import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:fvapp/utils/popups/loaders.dart';

class AddPackagePage extends StatefulWidget {
  final List<String> categories;

  const AddPackagePage({Key? key, required this.categories}) : super(key: key);

  @override
  _AddPackagePageState createState() => _AddPackagePageState();
}

class _AddPackagePageState extends State<AddPackagePage> {
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<File> _selectedImages = [];
  String? _selectedCategory;

  final PackageController _packageController = Get.put(PackageController());

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _savePackage() async {
    if (_packageNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedImages.isEmpty ||
        _selectedCategory == null) {
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Semua field harus diisi dan gambar harus dipilih.',
      );
      return;
    }

    try {
      await _packageController.addPackage(
        _packageNameController.text,
        _descriptionController.text,
        double.parse(_priceController.text),
        _selectedCategory!,
        _selectedImages.map((file) => file.path).toList(),
      );

      Navigator.of(context).pop();
      FVLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Paket berhasil ditambahkan.',
      );
    } catch (e) {
      print('Error occurred while adding package: $e');
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan saat menambahkan paket.',
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Paket Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedImages.isEmpty
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
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          File imageFile = _selectedImages[index];
                          return Stack(
                            children: [
                              Image.file(
                                imageFile,
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
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
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Paket',
                ),
                maxLines: 3,
              ),
              const SizedBox(width: double.infinity),
              ElevatedButton(
                onPressed: _savePackage,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
