import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
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
  final Package package;

  const FVProductCardVertical({
    required this.package,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    // Assume package.imageUrls is a list of URLs
    String? imageUrl;
    if (package.imageUrls != null && package.imageUrls.isNotEmpty) {
      imageUrl = package.imageUrls.first;
    } else {
      imageUrl = null; // No image available
    }

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetail(
        packageId: package.id, // Ensure you pass the correct packageId
        packageName: package.name,
        price: package.price,
        description: package.description, categoryId: '', package: package,
      )),
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
            // Thumbnail
            FVRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(FVSizes.sm),
              backgroundColor: dark ? FVColors.dark : FVColors.light,
              child: Stack(
                children: [
                  // Thumbnail image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(FVSizes.productImageRadius),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 180,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.error, size: 50),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FVSizes.spaceBtwItems / 2),

            // Name and Category
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FVProductTitleText(title: package.name, smallSize: true),
                const SizedBox(height: FVSizes.spaceBtwItems / 2),
                FVBrandTitleWithVerifiedIcon(
                  title: package.categoryId, // assuming categoryId is the category name
                ),
              ],
            ),

            // Spacer and price section
            Padding(
              padding: const EdgeInsets.only(left: FVSizes.md, right: FVSizes.md, top: FVSizes.spaceBtwItems / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  FVProductPriceText(
                    price: package.price,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
