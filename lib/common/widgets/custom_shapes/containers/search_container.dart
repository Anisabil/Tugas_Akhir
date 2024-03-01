import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/device_utility.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';

class FVSearchContainer extends StatelessWidget {
  const FVSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: FVSizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FVSizes.defaultSpace),
        child: Container(
          width: FVDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(FVSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? FVColors.dark
                    : FVColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(FVSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: FVColors.grey) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: dark ? FVColors.darkGrey : Colors.grey),
              const SizedBox(
                width: FVSizes.spaceBtwItems,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
