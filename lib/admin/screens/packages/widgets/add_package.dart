import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/category_controller.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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
  List<File> _imageFiles = [];
  List<File> _videoFiles = [];
  String? _selectedCategory;
  String? _selectedCategoryName;

  final CollectionReference _packagesRef = FirebaseFirestore.instance.collection('packages');
  final CategoryController _categoryController = Get.find<CategoryController>();

  List<VideoPlayerController> _videoControllers = [];
  List<ChewieController> _chewieControllers = [];
  List<Future<void>> _initializeVideoFutures = [];

  @override
  void initState() {
    super.initState();
    _categoryController.fetchCategories();
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
      var chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        aspectRatio: videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowMuting: true, // Added allowMuting property
        // other properties as needed
      );

      _videoControllers.add(videoPlayerController);
      _chewieControllers.add(chewieController);
      _initializeVideoFutures.add(videoPlayerController.initialize());
    });
  }
}

void _removeVideo(int index) {
  setState(() {
    _videoFiles.removeAt(index);

    _videoControllers[index].dispose();
    _chewieControllers[index].dispose();

    _videoControllers.removeAt(index);
    _chewieControllers.removeAt(index);
    _initializeVideoFutures.removeAt(index);
  });
}

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

void _savePackage() async {
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
    List<String> imageUrls = await _uploadFiles(_imageFiles, 'images');
    List<String> videoUrls = await _uploadFiles(_videoFiles, 'videos');

    Package package = Package(
      id: '',
      name: _packageNameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      categoryId: _selectedCategory!,
      categoryName: _selectedCategoryName!,
      imageUrls: imageUrls,
      videoUrls: videoUrls,
    );

    DocumentReference docRef = await _packagesRef.add(package.toJson());
    String packageId = docRef.id;

    await _packagesRef.doc(packageId).update({'id': packageId});

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


  Future<List<String>> _uploadFiles(List<File> files, String folder) async {
    List<String> urls = [];

    try {
      for (File file in files) {
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('packages/$folder/${file.path.split('/').last}')
            .putFile(file);
        urls.add(await snapshot.ref.getDownloadURL());
      }
    } catch (e) {
      print('Error uploading files: $e');
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Paket'),
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
              _imageFiles.isEmpty
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Iconsax.camera),
                  label: const Text('Pilih Gambar'),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Video',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _videoFiles.isEmpty
                  ? Container(
                      height: 200,
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
                                      aspectRatio: _chewieControllers[index].aspectRatio ?? 2 / 7,
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
                  icon: const Icon(Iconsax.video),
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
                  value: _selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                      _selectedCategoryName = _categoryController.categories.firstWhere((category) => category.id == newValue).name;
                    });
                  },
                  items: _categoryController.categories.map((category) {
                    return DropdownMenuItem(
                      key: ValueKey(category.id),
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePackage,
                  child: const Text('Simpan Paket'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
