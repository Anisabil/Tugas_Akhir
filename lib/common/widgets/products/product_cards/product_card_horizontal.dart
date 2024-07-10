import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
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
  final Package package;

  const FVProductCardHorizontal({Key? key, required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (package.imageUrls != null && package.imageUrls.isNotEmpty) {
      imageUrl = package.imageUrls.first;
    } else {
      imageUrl = null; // No image available
    }

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
                SizedBox(
                  height: 120,
                  width: 120,
                  child: imageUrl != null
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : Container(), // Placeholder or empty container if no image
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FVProductTitleText(title: package.name, smallSize: true),
                  const SizedBox(height: FVSizes.spaceBtwItems / 2),
                  FVBrandTitleWithVerifiedIcon(title: package.categoryName),
                  const SizedBox(height: FVSizes.spaceBtwItems + 6.6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Pricing
                      FVProductPriceText(price: package.price),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
