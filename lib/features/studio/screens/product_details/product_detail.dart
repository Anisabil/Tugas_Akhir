import 'package:flutter/material.dart';
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
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const FVBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1 - Product image slider
            const FVProductImageSlider(),

            // 2 - Product details
            Padding(
              padding: const EdgeInsets.only(
                  right: FVSizes.defaultSpace,
                  left: FVSizes.defaultSpace,
                  bottom: FVSizes.defaultSpace),
              child: Column(
                children: [
                  // Rating and share
                  const FVRatingAndShare(),

                  // Price, title, stock, and brand
                  const FVProductMetaData(),
                  const SizedBox(height: FVSizes.spaceBtwSection / 2),

                  // Attributes
                  const FVProductAttributes(),
                  const SizedBox(height: FVSizes.spaceBtwSection / 2),

                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Tahap Selanjutnya'),
                    ),
                  ),
                  const SizedBox(height: FVSizes.spaceBtwSection / 2),

                  // Description
                  const FVSectionHeading(
                    title: 'Deskripsi',
                    showActionButton: false,
                  ),
                  const SizedBox(height: FVSizes.spaceBtwItems),
                  const ReadMoreText(
                    'Include : 1 Hari Kerja, Unlimited Shoot, 1 Photographer/1 Camera, 1 Videographer/1 Camera, 50 Edited Photo, Retauche 2 Photo 16K + Frame, 1-2 Minutes Cinematic Video, Softfile in Google Drive + Flashdisk Master',
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
                  const SizedBox(height: FVSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const FVSectionHeading(
                        title: 'Ulasan(102)',
                        showActionButton: false,
                      ),
                      IconButton(
                          onPressed: () => Get.to(() => const ProductReviewsScreen()),
                          icon: const Icon(
                            Iconsax.arrow_right_3,
                            size: 18,
                          ))
                    ],
                  ),
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
