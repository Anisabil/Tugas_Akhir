import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:fvapp/utils/constants/colors.dart';
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
  List<File> _imageFiles = [];
  List<String> _videoUrls = [];
  List<File> _videoFiles = [];

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<VideoPlayerController> _videoControllers = [];
  List<ChewieController> _chewieControllers = [];
  List<Future<void>> _initializeVideoFutures = [];

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
      _imageFiles.removeAt(index);
    });
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

  void _savePackage() async {
    if (_packageNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Semua field harus diisi.',
      );
      return;
    }

    try {
      List<String> imageUrls = [];
      for (File imageFile in _imageFiles) {
        String? imageUrl = await _uploadFile(imageFile, 'images');
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      List<String> videoUrls = [];
      for (File videoFile in _videoFiles) {
        String? videoUrl = await _uploadFile(videoFile, 'videos');
        if (videoUrl != null) {
          videoUrls.add(videoUrl);
        }
      }

      await _databaseReference.child('packages').push().set({
        'name': _packageNameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'imageUrls': imageUrls,
        'videoUrls': videoUrls,
      });

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

  Future<String?> _uploadFile(File file, String folder) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('packages/$folder/${file.path.split('/').last}')
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
              DropdownButtonFormField<String>(
                value: widget.categories.isNotEmpty ? widget.categories[0] : null,
                onChanged: (newValue) {
                  // Handle dropdown value change
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
