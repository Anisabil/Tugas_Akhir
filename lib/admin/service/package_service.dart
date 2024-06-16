import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:uuid/uuid.dart';

class PackageService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('packages');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  Future<void> addPackage(String name, String description, double price, String categoryId, List<String> imagePaths) async {
    String id = _uuid.v4();
    List<String> imageUrls = await uploadImages(imagePaths, id);

    Package package = Package(
      id: id,
      name: name,
      description: description,
      price: price,
      categoryId: categoryId,
      imageUrls: imageUrls,
    );

    await _dbRef.child(id).set(package.toJson());
  }

  Future<void> updatePackage(String id, String name, String description, double price, String categoryId, List<String>? imagePaths) async {
    List<String>? imageUrls;

    if (imagePaths != null) {
      imageUrls = await uploadImages(imagePaths, id);
    }

    await _dbRef.child(id).update({
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
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

  Future<List<String>> uploadImages(List<String> imagePaths, String packageId) async {
    List<String> imageUrls = [];
    for (String imagePath in imagePaths) {
      File file = File(imagePath);
      TaskSnapshot snapshot = await _storage.ref('packages/$packageId/${_uuid.v4()}').putFile(file);
      imageUrls.add(await snapshot.ref.getDownloadURL());
    }
    return imageUrls;
  }
}
