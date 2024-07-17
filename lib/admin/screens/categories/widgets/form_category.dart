import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/controllers/category_controller.dart';

class CategoryFormScreen extends StatefulWidget {
  final String? categoryId;
  final String? initialName;
  final String? initialImageUrl;

  CategoryFormScreen({this.categoryId, this.initialName, this.initialImageUrl});

  @override
  _CategoryFormScreenState createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final _formKey = GlobalKey<FormState>();
  String? _name;
  File? _imageFile;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    isEdit = widget.categoryId != null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  Future<String> _uploadFile(File file) async {
    try {
      var snapshot = await FirebaseStorage.instance
          .ref('categories/${file.path.split('/').last}')
          .putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String imageUrl = widget.initialImageUrl ?? '';

      if (_imageFile != null) {
        imageUrl = await _uploadFile(_imageFile!);
      }

      if (widget.categoryId == null) {
        categoryController.addCategory(_name!, imageUrl);
      } else {
        categoryController.updateCategory(widget.categoryId!, _name!, imageUrl);
      }
      Navigator.of(context).pop();
    }
  }

  void _deleteCategory() {
    try {
      categoryController.deleteCategory(widget.categoryId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryId == null ? 'Tambah Kategori' : 'Edit Kategori'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Nama Kategori'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mohon diisi nama kategori';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                const SizedBox(height: 16),
                _imageFile == null
                    ? (isEdit && widget.initialImageUrl != null
                        ? Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.initialImageUrl!),
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
                    : Stack(
                        children: [
                          Image.file(
                            _imageFile!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: _removeImage,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera),
                    label: const Text('Select Image'),
                  ),
                ),
                const SizedBox(height: FVSizes.spaceBtwSection * 8),
                Row(
                  children: [
                    if (isEdit) // Hanya tampilkan tombol hapus jika sedang dalam mode edit
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _deleteCategory,
                          child: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FVColors.error,
                          ),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(widget.categoryId == null ? 'Add' : 'Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
