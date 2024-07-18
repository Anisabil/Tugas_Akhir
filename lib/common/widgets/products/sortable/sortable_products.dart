import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class FVSortableProducts extends StatelessWidget {
  FVSortableProducts({super.key});

  final PackageController _packageController = Get.put(PackageController());
  final RxString _selectedPackageName = ''.obs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _packageController.fetchPackages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: [
              // Dropdown
              Obx(() {
                // Mendapatkan daftar nama paket yang unik
                List<String> uniquePackageNames = _packageController.packages
                    .map((package) => package.name)
                    .toSet()
                    .toList();

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                  value: _selectedPackageName.value.isEmpty
                      ? null
                      : _selectedPackageName.value,
                  onChanged: (value) {
                    if (value != null) {
                      _selectedPackageName.value = value;
                      _packageController.filterPackagesByName(value);
                    }
                  },
                  items: uniquePackageNames.map((name) {
                    return DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Product
              Obx(
                () => _packageController.filteredPackages.isEmpty
                    ? const CircularProgressIndicator()
                    : FVGridLayout(
                        itemCount: _packageController.filteredPackages.length,
                        itemBuilder: (_, index) => FVProductCardVertical(
                          package: _packageController.filteredPackages[index],
                        ),
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}
