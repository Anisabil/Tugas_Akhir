import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/category_model.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/admin/service/category_service.dart';
import 'package:fvapp/admin/service/package_service.dart';
import 'package:get/get.dart';

class PackageController extends GetxController {
  final CollectionReference packagesCollection =
      FirebaseFirestore.instance.collection('packages');
var packages = <Package>[].obs;
  var categories = <Category>[].obs;
  final PackageService _packageService = PackageService();
  final CategoryService _categoryService = CategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
    fetchCategories();
  }

  void fetchPackages() async {
    try {
      QuerySnapshot snapshot = await packagesCollection.get();
      packages.assignAll(snapshot.docs.map((doc) => Package.fromFirestore(doc)).toList());
    } catch (e) {
      print('Error fetching packages: $e');
    }
  }

  void fetchCategories() async {
    try {
      categories.value = await _categoryService.getCategories();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<Package?> getPackageById(String id) async {
    try {
      var package = await _packageService.getPackageById(id);
      return package;
    } catch (e) {
      print("Error fetching package by ID: $e");
      return null;
    }
  }

  void search(String query) async {
    if (query.isEmpty) {
      // Reset daftar jika query kosong
      packages.assignAll(await _packageService.getPackages());
    } else {
      // Filter berdasarkan nama, harga, dan kategori
      var fetchedPackages = await _packageService.getPackages();
      var result = fetchedPackages.where((package) =>
          package.name.toLowerCase().contains(query.toLowerCase()) ||
          package.price.toString().toLowerCase().contains(query.toLowerCase()) ||
          package.categoryId.toLowerCase().contains(query.toLowerCase()));
      packages.assignAll(result.toList());
    }
  }

  // Method untuk mendapatkan semua paket
  Future<List<Package>> getPackages() async {
  List<Package> packages = [];

  try {
    QuerySnapshot snapshot = await packagesCollection.get();
    snapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>?; // Konversi ke Map<String, dynamic>?
      if (data != null) {
        packages.add(Package(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          categoryId: data['categoryId'] ?? '',
          imageUrls: List<String>.from(data['imageUrls'] ?? []),
          videoUrls: List<String>.from(data['videoUrls'] ?? []), 
          categoryName: '',
        ));
      } else {
        print('Document data was null for document ${doc.id}');
      }
    });
  } catch (e) {
    print('Error fetching packages: $e');
  }

  return packages;
}

String getCategoryNameById(String categoryId) {
    return categories.firstWhere((category) => category.id == categoryId, orElse: () => Category(id: '', name: 'Unknown', imageUrl: '')).name;
  }

  // Method untuk menambahkan paket baru
  Future<void> addPackage(Package package) async {
    try {
      await packagesCollection.add({
        'name': package.name,
        'description': package.description,
        'price': package.price,
        'categoryId': package.categoryId,
        'imageUrls': package.imageUrls,
        'videoUrls': package.videoUrls,
      });
    } catch (e) {
      print('Error adding package: $e');
    }
  }

  // Method untuk mengupdate paket
  Future<void> updatePackage(Package package) async {
    try {
      await packagesCollection.doc(package.id).update({
        'name': package.name,
        'description': package.description,
        'price': package.price,
        'categoryId': package.categoryId,
        'imageUrls': package.imageUrls,
        'videoUrls': package.videoUrls,
      });
    } catch (e) {
      print('Error updating package: $e');
    }
  }

  // Method untuk menghapus paket
  Future<void> deletePackage(String packageId) async {
    try {
      await packagesCollection.doc(packageId).delete();
    } catch (e) {
      print('Error deleting package: $e');
    }
  }
}
