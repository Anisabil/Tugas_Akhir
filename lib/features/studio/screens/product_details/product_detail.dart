import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/product_attributes.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/product_meta_data.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/rating_share_widget.dart';
import 'package:fvapp/features/studio/screens/product_reviews/product_reviews.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class ProductDetail extends StatelessWidget {
  final Package package;
  final String packageId;
  final String packageName;
  final double price;
  final String description;
  final String categoryId;

  const ProductDetail({
    Key? key,
    required this.package,
    required this.packageName,
    required this.price,
    required this.description, required this.categoryId, required this.packageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FVBottomAddToCart(package: package),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1 - Product image slider
            FVProductImageSlider(packageId: packageId),

            // 2 - Product details
            Padding(
              padding: const EdgeInsets.only(
                  right: FVSizes.defaultSpace,
                  left: FVSizes.defaultSpace,
                  bottom: FVSizes.defaultSpace),
              child: Column(
                children: [
                  // Price, title, stock, and brand
                  FVProductMetaData(
                    packageName: packageName,
                    price: price,
                    categoryId: categoryId,
                  ),
                  const SizedBox(height: FVSizes.spaceBtwSection / 2),

                  // Attributes
                  FVProductAttributes(price: price),
                  const SizedBox(height: FVSizes.spaceBtwSection / 2),

                  // Description
                  const FVSectionHeading(
                    title: 'Deskripsi',
                    showActionButton: false,
                  ),
                  const SizedBox(height: FVSizes.spaceBtwItems),
                  ReadMoreText(
                    description,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Lebih banyak',
                    trimExpandedText: 'Lebih sedikit',
                    moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  // Reviews
                  const Divider(),
                  const SizedBox(height: FVSizes.spaceBtwSection),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
