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
import '../../common/styles/shadows.dart';
import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../common/widgets/images/fv_rounded_image.dart';

class FVCardVertical extends StatelessWidget {
  const FVCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return GestureDetector(
      // onTap: () => Get.to(() => const ProductDetail()),
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
              height: 100,
              padding: const EdgeInsets.all(FVSizes.sm),
              backgroundColor: dark ? FVColors.dark : FVColors.light,
              child: const Stack(
                children: [
                  // Thumbnail image
                  FVRoundedImage(
                    imageUrl: FVImages.contoh3,
                    applyImageRadius: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: FVSizes.spaceBtwItems / 2),

            // Details
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FVProductTitleText(title: 'Wedding Package', smallSize: true),
                SizedBox(height: FVSizes.spaceBtwItems / 2),
              ],
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                const Padding(
                    padding: EdgeInsets.only(left: FVSizes.md),
                    child: FVProductTitleText(
                      title: 'Wedding',
                      smallSize: true,
                    )),
                // Add to Card Button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.gallery_edit,
                            color: dark ? FVColors.white : FVColors.black),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.trash4,
                            color: dark ? FVColors.white : FVColors.black),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
