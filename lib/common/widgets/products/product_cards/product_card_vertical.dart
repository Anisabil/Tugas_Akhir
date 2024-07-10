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
import 'package:fvapp/admin/controllers/package_controller.dart'; // import the controller

class FVProductCardVertical extends StatelessWidget {
  final Package package;
  final PackageController packageController = Get.find(); // get the instance of the controller

  FVProductCardVertical({
    required this.package,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    String? imageUrl = package.imageUrls.isNotEmpty ? package.imageUrls.first : null;
    String categoryName = packageController.getCategoryNameById(package.categoryId); // get the category name by ID

    return GestureDetector(
      onTap: () {
        print('Navigating to ProductDetail with packageId: ${package.id}');
        Get.to(() => ProductDetail(
          packageId: package.id,
          packageName: package.name,
          price: package.price,
          description: package.description,
          categoryId: package.categoryId,
          categoryName: categoryName, // pass the category name
          package: package,
          videoUrls: package.videoUrls,
        ));
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [FVShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(FVSizes.productImageRadius),
          color: dark ? FVColors.darkerGrey : FVColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FVRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(FVSizes.sm),
              backgroundColor: dark ? FVColors.dark : FVColors.light,
              child: Stack(
                children: [
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
            Padding(
              padding: const EdgeInsets.only(left: FVSizes.md, right: FVSizes.md, top: FVSizes.spaceBtwItems / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FVProductTitleText(title: package.name, smallSize: true),
                  const SizedBox(height: FVSizes.spaceBtwItems / 2),
                  FVBrandTitleWithVerifiedIcon(
                    title: categoryName, // Display the category name here
                  ),
                  const SizedBox(height: FVSizes.spaceBtwItems / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FVProductPriceText(
                        price: package.price,
                      ),
                    ],
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
