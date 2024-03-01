import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/icons/fv_circular_icon.dart';
import 'package:fvapp/common/widgets/texts/product_title_text.dart';
import 'package:fvapp/features/studio/screens/product_details/product_detail.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../images/fv_rounded_image.dart';
import '../../texts/fv_brand_title_with_verified_icon.dart';
import '../../texts/product_price_text.dart';

class FVProductCardVertical extends StatelessWidget {
  const FVProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() =>const ProductDetail()),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [FVShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(FVSizes.productImageRadius),
          color: dark ? FVColors.darkerGrey : FVColors.white,
        ),
        child: Column(
          children: [
            // Thumbnail, Wishlist Button, Discount Tag
            FVRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(FVSizes.sm),
              backgroundColor: dark ? FVColors.dark : FVColors.light,
              child: Stack(
                children: [
                  // Thumbnail image
                  const FVRoundedImage(
                    imageUrl: FVImages.contoh1,
                    applyImageRadius: true,
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
            const SizedBox(height: FVSizes.spaceBtwItems / 2),

            // Details
            const Padding(
              padding: EdgeInsets.only(left: FVSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FVProductTitleText(title: 'Wedding Package', smallSize: true),
                  SizedBox(height: FVSizes.spaceBtwItems / 2),
                  FVBrandTitleWithVerifiedIcon(
                    title: 'Wedding',
                  ),
                ],
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                const Padding(
                  padding: EdgeInsets.only(left: FVSizes.sm),
                  child: FVProductPriceText(
                    price: '1.500',
                  ),
                ),

                // Add to Card Button
                Container(
                  decoration: const BoxDecoration(
                    color: FVColors.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(FVSizes.cardRadiusMd),
                      bottomRight: Radius.circular(FVSizes.productImageRadius),
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
      ),
    );
  }
}
