import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/category_model.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/controllers/category_controller.dart';

class EditPackagePage extends StatefulWidget {
  final String packageId;
  final String packageName;
  final List<File> imageFiles;
  final List<String> imageUrls;
  final List<File> videoFiles;
  final List<String> videoUrls;
  final int price;
  final String description;
  final String selectedCategory;

  const EditPackagePage({
    Key? key,
    required this.packageId,
    required this.packageName,
    required this.imageFiles,
    required this.imageUrls,
    required this.videoFiles,
    required this.videoUrls,
    required this.price,
    required this.description,
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
  List<File> _videoFiles = [];
  List<String> _videoUrls = [];
  String? _selectedCategory;

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final CategoryController _categoryController = Get.find<CategoryController>();
  Category? getCategoryById(String categoryId) {
  return _categoryController.categories.firstWhereOrNull((category) => category.id == categoryId);
}

  List<VideoPlayerController> _videoControllers = [];
  List<ChewieController> _chewieControllers = [];
  List<Future<void>> _initializeVideoFutures = [];

  @override
  void initState() {
    super.initState();
    _packageNameController.text = widget.packageName;
    _priceController.text = widget.price.toString();
    _descriptionController.text = widget.description;
    _categoryController.fetchCategories();
    _imageFiles = widget.imageFiles;
    _imageUrls = widget.imageUrls;
    _videoFiles = widget.videoFiles;
    _videoUrls = widget.videoUrls;

    _initializeVideoControllers();

    // Fetch categories
    _categoryController.fetchCategories();
  }

  void _initializeVideoControllers() {
    for (var videoFile in _videoFiles) {
      var videoPlayerController = VideoPlayerController.file(videoFile);
      _videoControllers.add(videoPlayerController);
      _initializeVideoFutures.add(videoPlayerController.initialize());

      var chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
      _chewieControllers.add(chewieController);
    }

    for (var videoUrl in _videoUrls) {
      var videoPlayerController = VideoPlayerController.network(videoUrl);
      _videoControllers.add(videoPlayerController);
      _initializeVideoFutures.add(videoPlayerController.initialize());

      var chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
      _chewieControllers.add(chewieController);
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    for (var chewieController in _chewieControllers) {
      chewieController.dispose();
    }
    super.dispose();
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

  Future<void> _pickVideos() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        File videoFile = File(pickedFile.path);
        _videoFiles.add(videoFile);

        var videoPlayerController = VideoPlayerController.file(videoFile);
        _videoControllers.add(videoPlayerController);

        var chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: videoPlayerController.value.aspectRatio,
          autoPlay: false,
          looping: false,
        );
        _chewieControllers.add(chewieController);

        _initializeVideoFutures.add(videoPlayerController.initialize());
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

  void _removeVideo(int index) {
    setState(() {
      if (index < _videoFiles.length) {
        _videoFiles.removeAt(index);
      } else {
        _videoUrls.removeAt(index - _videoFiles.length);
      }

      _videoControllers[index].dispose();
      _chewieControllers[index].dispose();

      _videoControllers.removeAt(index);
      _chewieControllers.removeAt(index);
      _initializeVideoFutures.removeAt(index);
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
        String? imageUrl = await _uploadFile(imageFile, widget.packageId, 'images');
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      List<String> videoUrls = _videoUrls;
      for (File videoFile in _videoFiles) {
        String? videoUrl = await _uploadFile(videoFile, widget.packageId, 'videos');
        if (videoUrl != null) {
          videoUrls.add(videoUrl);
        }
      }

      await _databaseReference.child('packages/${widget.packageId}').update({
        'name': _packageNameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'categoryId': _selectedCategory,
        'imageUrls': imageUrls,
        'videoUrls': videoUrls,
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

  Future<String?> _uploadFile(File file, String packageId, String folder) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('packages/$packageId/$folder/${file.path.split('/').last}')
          .putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
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
              const Text(
                'Gambar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                            return Container(
                              width: 200,
                              height: 200,
                              child: Stack(
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
                                      icon: const Icon(Icons.cancel, color: FVColors.gold),
                                      onPressed: () => _removeImage(index),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            int urlIndex = index - _imageFiles.length;
                            return Container(
                              width: 200,
                              height: 200,
                              child: Stack(
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
                              ),
                            );
                          }
                        },
                      ),
                    ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pilih Gambar'),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Video',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _videoFiles.isEmpty && _videoUrls.isEmpty
                  ? Container(
                      height: 600,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text('Tidak ada video yang dipilih'),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _chewieControllers.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                            future: _initializeVideoFutures[index],
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: _chewieControllers[index].aspectRatio ?? 16 / 9,
                                      child: Chewie(controller: _chewieControllers[index]),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.cancel, color: FVColors.gold),
                                        onPressed: () => _removeVideo(index),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                  width: 200,
                                  height: 600,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickVideos,
                  icon: const Icon(Icons.video_library),
                  label: const Text('Pilih Video'),
                ),
              ),
              const SizedBox(height: 32),

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
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: _selectedCategory, // Menggunakan nilai _selectedCategory yang sudah diatur sebelumnya
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue; // Memperbarui nilai _selectedCategory saat ada perubahan
                    });
                  },
                  items: _categoryController.categories.map((category) {
                    return DropdownMenuItem(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Kategori Paket',
                  ),
                );
              }),

              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Paket',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.packageName.isNotEmpty)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _deletePackage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Hapus Paket'),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updatePackage,
                      child: const Text('Simpan Perubahan'),
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

