import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/icons/fv_circular_icon.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

class FVBottomAddToCart extends StatelessWidget {
  const FVBottomAddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: FVSizes.defaultSpace, vertical: FVSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? FVColors.darkerGrey : FVColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(FVSizes.cardRadiusLg),
          topRight: Radius.circular(FVSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const FVCircularIcon(
                icon: Iconsax.minus,
                backgroundColor: FVColors.darkerGrey,
                width: 40,
                height: 40,
                color: FVColors.white,
              ),
              const SizedBox(width: FVSizes.spaceBtwItems),
              Text(
                '2',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(width: FVSizes.spaceBtwItems),
              const FVCircularIcon(
                icon: Iconsax.add,
                backgroundColor: FVColors.black,
                width: 40,
                height: 40,
                color: FVColors.white,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(FVSizes.md),
              backgroundColor: FVColors.black,
              side: const BorderSide(color: FVColors.black),
            ),
            child: const Text('Keranjang'),
          )
        ],
      ),
    );
  }
}
