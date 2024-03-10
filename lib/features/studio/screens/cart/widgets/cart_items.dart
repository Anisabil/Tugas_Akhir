import 'package:flutter/material.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class FVCartItems extends StatelessWidget {
  const FVCartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      separatorBuilder: (_, __) =>
          const SizedBox(height: FVSizes.spaceBtwSection),
      itemBuilder: (_, index) => Column(
        children: [
          // Cart Item
          const FVCartItem(),
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
                  // Add remove buttons
                  FVProductQuantityWithAddRemoveButton(),
                ],
              ),
              FVProductPriceText(price: '246')
            ],
          )
        ],
      ),
    );
  }
}
