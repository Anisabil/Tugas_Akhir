import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:fvapp/admin/screens/packages/widgets/add_package.dart';
import 'package:fvapp/admin/screens/packages/widgets/edit_package_page.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class SettingPackages extends StatelessWidget {
  final PackageController packageController = Get.put(PackageController());

  void _navigateToAddPackage(BuildContext context, List<String> categoryName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPackagePage(
          categories: categoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<PackageController>(
          init: packageController,
          builder: (controller) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: controller.packages.length,
              itemBuilder: (context, index) {
                var package = controller.packages[index];
                String? imageUrl =
                    package.imageUrls.isNotEmpty ? package.imageUrls[0] : null;

                return GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPackagePage(
                        packageId: package.id,
                        packageName: package.name,
                        imageFiles: [], // Initialize with an empty list or the actual list of images
                        imageUrls: package.imageUrls,
                        videoFiles: [],
                        videoUrls: package.videoUrls,
                        price: package.price.toInt(),
                        description: package.description,
                        selectedCategory: package.categoryId,
                      ),
                    ));
                    // Setelah kembali dari EditPackagePage, pastikan untuk memuat ulang data paket
                    packageController.fetchPackages();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Text('Gambar tidak tersedia'),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text('Gambar Paket'),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(package.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Fetch categories first before navigating
          packageController.fetchCategories();
          List<String> categoryNames = packageController.categories.map((category) => category.name).toList();
          _navigateToAddPackage(context, categoryNames);
        },
        child: const Icon(Iconsax.add),
        backgroundColor: FVColors.gold,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
