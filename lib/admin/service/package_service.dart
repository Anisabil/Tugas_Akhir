import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fvapp/admin/models/category_model.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:uuid/uuid.dart';

class PackageService {
  final CollectionReference _packagesRef = FirebaseFirestore.instance.collection('packages');
  final CollectionReference _categoriesRef = FirebaseFirestore.instance.collection('categories');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  Future<List<Package>> getPackages() async {
    QuerySnapshot snapshot = await _packagesRef.get();
    List<Package> packages = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Package package = Package.fromJson(doc.data() as Map<String, dynamic>);
      // Optionally fetch category name if needed
      // package.categoryName = await _getCategoryName(package.categoryId);
      packages.add(package);
    }

    return packages;
  }

  Future<Package?> getPackageById(String id) async {
    try {
      DocumentSnapshot doc = await _packagesRef.doc(id).get();
      if (doc.exists) {
        return Package.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Package not found');
      }
    } catch (e) {
      print('Error getting package by ID: $e');
      return null; // Handle error gracefully in your application
    }
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

  Future<void> addPackage(Package package, List<String> imagePaths, List<String> videoPaths) async {
    try {
      List<String> imageUrls = await uploadFiles(imagePaths, package.id, 'images');
      List<String> videoUrls = await uploadFiles(videoPaths, package.id, 'videos');

      package.imageUrls.addAll(imageUrls);
      package.videoUrls.addAll(videoUrls);

      await _packagesRef.doc(package.id).set(package.toJson());
    } catch (e) {
      print('Error adding package: $e');
      throw Exception('Failed to add package');
    }
  }

  Future<void> updatePackage(Package package, List<String>? imagePaths, List<String>? videoPaths) async {
    try {
      if (imagePaths != null && imagePaths.isNotEmpty) {
        List<String> newImageUrls = await uploadFiles(imagePaths, package.id, 'images');
        package.imageUrls.addAll(newImageUrls);
      }

      if (videoPaths != null && videoPaths.isNotEmpty) {
        List<String> newVideoUrls = await uploadFiles(videoPaths, package.id, 'videos');
        package.videoUrls.addAll(newVideoUrls);
      }

      await _packagesRef.doc(package.id).update(package.toJson());
    } catch (e) {
      print('Error updating package: $e');
      throw Exception('Failed to update package');
    }
  }

  Future<void> deletePackage(String id) async {
    try {
      await _packagesRef.doc(id).delete();
    } catch (e) {
      print('Error deleting package: $e');
      throw Exception('Failed to delete package');
    }
  }

  Future<List<Category>> getCategories() async {
    QuerySnapshot querySnapshot = await _categoriesRef.get();
    List<Category> categories = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Category category = Category.fromJson(data);
      categories.add(category);
    });

    return categories;
  }
}
