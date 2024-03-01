import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

class FVBrandShowcase extends StatelessWidget {
  const FVBrandShowcase({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return FVRoundedContainer(
      showBorder: true,
      borderColor: FVColors.darkGrey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(FVSizes.md),
      margin: const EdgeInsets.only(bottom: FVSizes.spaceBtwItems),
      child: Column(
        children: [
          // Brand with Product Count
          const FVBrandCard(showBorder: false),
          const SizedBox(
            height: FVSizes.spaceBtwItems,
          ),

          // Brand Top 3
          Row(
            children: images
                .map((image) =>
                    brandTopProductImageWidget(String, image, context))
                .toList(),
          ),
        ],
      ),
    );
  }
}

Widget brandTopProductImageWidget(String, image, context) {
  return Expanded(
    child: FVRoundedContainer(
      height: 100,
      backgroundColor: FVHelperFunctions.isDarkMode(context)
          ? FVColors.darkerGrey
          : FVColors.light,
      margin: const EdgeInsets.only(right: FVSizes.sm),
      padding: const EdgeInsets.all(FVSizes.md),
      child: Image(
        fit: BoxFit.contain,
        image: AssetImage(image),
      ),
    ),
  );
}
