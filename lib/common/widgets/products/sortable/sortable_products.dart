import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class FVSortableProducts extends StatelessWidget {
  const FVSortableProducts({
    super.key,
  });

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
            'Siraman Package',
            'Album Magazine Photo',
          ]
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
        ),
        const SizedBox(height: FVSizes.spaceBtwSection),

        // Product
        FVGridLayout(
            itemCount: 8,
            itemBuilder: (_, index) => const FVProductCardVertical())
      ],
    );
  }
}
