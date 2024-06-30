import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:uuid/uuid.dart';

class PackageService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('packages');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  Future<void> addPackage(String name, String description, double price, String categoryId, List<String> imagePaths, List<String> videoPaths) async {
    String id = _uuid.v4();
    List<String> imageUrls = await uploadFiles(imagePaths, id, 'images');
    List<String> videoUrls = await uploadFiles(videoPaths, id, 'videos');

    Package package = Package(
      id: id,
      name: name,
      description: description,
      price: price,
      categoryId: categoryId,
      imageUrls: imageUrls,
      videoUrls: videoUrls,
    );

    await _dbRef.child(id).set(package.toJson());
  }

  Future<void> updatePackage(String id, String name, String description, double price, String categoryId, List<String>? imagePaths, List<String>? videoPaths) async {
    List<String>? imageUrls;
    List<String>? videoUrls;

    if (imagePaths != null) {
      imageUrls = await uploadFiles(imagePaths, id, 'images');
    }
    if (videoPaths != null) {
      videoUrls = await uploadFiles(videoPaths, id, 'videos');
    }

    await _dbRef.child(id).update({
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
    });
  }

  Future<void> deletePackage(String id) async {
    await _dbRef.child(id).remove();
  }

  Future<List<Package>> getPackages() async {
    DataSnapshot snapshot = await _dbRef.get();
    List<Package> packages = [];
    if (snapshot.value != null) {
      Map<dynamic, dynamic> packageMap = snapshot.value as Map<dynamic, dynamic>;
      packageMap.forEach((key, value) {
        packages.add(Package.fromJson(Map<String, dynamic>.from(value)));
      });
    }
    return packages;
  }

  Future<List<String>> uploadFiles(List<String> filePaths, String packageId, String folder) async {
    List<String> fileUrls = [];
    for (String filePath in filePaths) {
      File file = File(filePath);
      TaskSnapshot snapshot = await _storage.ref('packages/$packageId/$folder/${_uuid.v4()}').putFile(file);
      fileUrls.add(await snapshot.ref.getDownloadURL());
    }
    return fileUrls;
  }
}
