import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class FVSortableProducts extends StatelessWidget {
  FVSortableProducts({
    super.key,
  });

  final PackageController _packageController = Get.put(PackageController());


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {},
          items: [
            'Wedding Package',
            'Prewedding Package',
            'Engagement Package',
          ]
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
        ),
        const SizedBox(height: FVSizes.spaceBtwSection),

        // Product
        Obx(
                    () => _packageController.packages.isEmpty
                        ? const CircularProgressIndicator()
                        : FVGridLayout(
                            itemCount: _packageController.packages.length,
                            itemBuilder: (_, index) => FVProductCardVertical(
                              package: _packageController.packages[index],
                            ),
                          ),
                  ),
      ],
    );
  }
}
