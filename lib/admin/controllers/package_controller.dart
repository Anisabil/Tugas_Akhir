import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/admin/service/package_service.dart';
import 'package:get/get.dart';

class PackageController extends GetxController {
  var packages = <Package>[].obs;
  final PackageService _packageService = PackageService();

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  void fetchPackages() async {
    packages.value = await _packageService.getPackages();
  }

  Future<void> addPackage(String name, String description, double price, String categoryId, List<String> imagePaths, List<String> videoPaths) async {
    await _packageService.addPackage(name, description, price, categoryId, imagePaths, videoPaths);
    fetchPackages();
  }

  Future<void> updatePackage(String id, String name, String description, double price, String categoryId, List<String>? imagePaths, List<String>? videoPaths) async {
    await _packageService.updatePackage(id, name, description, price, categoryId, imagePaths, videoPaths);
    fetchPackages();
  }

  Future<void> deletePackage(String id) async {
    await _packageService.deletePackage(id);
    fetchPackages();
  }
}
