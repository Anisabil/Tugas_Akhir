import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/images/fv_rounded_image.dart';
import 'package:fvapp/common/widgets/texts/fv_brand_title_with_verified_icon.dart';
import 'package:fvapp/common/widgets/texts/product_price_text.dart';
import 'package:fvapp/common/widgets/texts/product_title_text.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../icons/fv_circular_icon.dart';

class FVProductCardHorizontal extends StatelessWidget {
  const FVProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Container(
      width: 310,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FVSizes.productImageRadius),
        color: dark ? FVColors.darkerGrey : FVColors.softGrey,
      ),
      child: Row(
        children: [
          // Thumbnail
          FVRoundedContainer(
            height: 120,
            padding: const EdgeInsets.all(FVSizes.sm),
            backgroundColor: dark ? FVColors.dark : FVColors.light,
            child: Stack(
              children: [
                // Thumbnail Image
                const SizedBox(
                  height: 120,
                  width: 120,
                  child: FVRoundedImage(
                      imageUrl: FVImages.contoh3, applyImageRadius: true),
                ),

                // Sale Tag
                Positioned(
                  top: 12,
                  child: FVRoundedContainer(
                    radius: FVSizes.sm,
                    backgroundColor: FVColors.secondary.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: FVSizes.sm, vertical: FVSizes.xs),
                    child: Text(
                      '25%',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .apply(color: FVColors.black),
                    ),
                  ),
                ),

                // Favorite Icon Button
                const Positioned(
                  top: 0,
                  right: 0,
                  child: FVCircularIcon(
                    icon: Iconsax.heart5,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Details
          SizedBox(
            width: 172,
            child: Padding(
              padding: const EdgeInsets.only(top: FVSizes.md, left: FVSizes.sm),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FVProductTitleText(
                          title: 'Basic Package', smallSize: true),
                      const SizedBox(height: FVSizes.spaceBtwItems / 2),
                      const FVBrandTitleWithVerifiedIcon(title: 'Wedding'),
                      const SizedBox(height: FVSizes.spaceBtwItems + 6.6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Pricing
                          const FVProductPriceText(price: '1000'),

                          // Add to Card
                          Container(
                            decoration: const BoxDecoration(
                              color: FVColors.dark,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(FVSizes.cardRadiusMd),
                                bottomRight:
                                    Radius.circular(FVSizes.productImageRadius),
                              ),
                            ),
                            child: const SizedBox(
                              width: FVSizes.iconLg * 1.2,
                              height: FVSizes.iconLg * 1.2,
                              child: Center(
                                child: Icon(Iconsax.add, color: FVColors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
