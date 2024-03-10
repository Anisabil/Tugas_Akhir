import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/screens/cart/cart.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';

class FVCartCounterIcon extends StatelessWidget {
  const FVCartCounterIcon({
    super.key,
    this.iconColor, 
    this.counterBgColor, 
    this.counterTextColor,
    required this.onPressed,
  });

  
  final VoidCallback onPressed;
  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Stack(
      children: [
        IconButton(
          onPressed: () => Get.to(() => const CartScreen()),
          icon: Icon(
            Iconsax.bag,
            color: iconColor,
          ),
      ),
      Positioned(
        right: 0,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: counterBgColor ?? (dark ? FVColors.white : FVColors.black),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              '2',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .apply(color: counterTextColor ?? (dark ? FVColors.black : FVColors.white), fontSizeFactor: 0.8),
            ),
          ),
        ),
      ),
    ]);
  }
}
