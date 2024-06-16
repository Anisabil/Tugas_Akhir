import 'package:flutter/material.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class FVCartItems extends StatelessWidget {
  final Map<String, dynamic> formData;
  final bool showAddRemoveButtons;

  const FVCartItems({
    Key? key,
    this.showAddRemoveButtons = true,
    required this.formData,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Tambahkan pernyataan print untuk memeriksa imageUrl
    print('Image URL: ${formData['selectedPackageImageUrl']}');

    return Column(
      children: [
        // Cart Item
        FVCartItem(
          imageUrl: formData['selectedPackageImageUrl'] ?? '',
          category: formData['selectedPackageCategory'] ?? '',
          name: formData['selectedPackageName'] ?? '',
        ),
        if (showAddRemoveButtons) const SizedBox(height: FVSizes.spaceBtwItems),

        // Add remove button row with total price
        if (showAddRemoveButtons) 
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // extra space
                SizedBox(width: 70),
              ],
            ),
          ],
        )
      ],
    );
  }
}
