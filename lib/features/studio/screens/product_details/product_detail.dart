import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/product_attributes.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:fvapp/features/studio/screens/product_details/widgets/product_meta_data.dart';
import 'package:fvapp/features/studio/screens/product_reviews/product_reviews.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:video_player/video_player.dart';

class ProductDetail extends StatelessWidget {
  final Package package;
  final String packageId;
  final String packageName;
  final double price;
  final String description;
  final String categoryId;
  final String categoryName;
  final List<String> videoUrls;

  ProductDetail({
  Key? key,
  required this.package,
  required this.packageName,
  required this.price,
  required this.description,
  required this.categoryId,
  required this.categoryName,
  required this.packageId,
  required this.videoUrls,
}) : super(key: key) {
  print('ProductDetail initialized with packageId: $packageId, packageName: $packageName');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FVBottomAddToCart(package: package, packageId: packageId,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1 - Product image slider
            FVProductImageSlider(packageId: packageId),

            // 2 - Product details
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: FVSizes.defaultSpace,
                  vertical: FVSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price, title, stock, and brand
                  FVProductMetaData(
                    packageName: packageName,
                    price: price,
                    categoryName: categoryName,
                  ),
                  SizedBox(height: FVSizes.spaceBtwSection),

                  // Attributes
                  FVProductAttributes(price: price),
                  SizedBox(height: FVSizes.spaceBtwSection),

                  // Description
                  FVSectionHeading(
                    title: 'Deskripsi',
                    showActionButton: false,
                  ),
                  SizedBox(height: FVSizes.spaceBtwItems),
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
                  Divider(),
                  SizedBox(height: FVSizes.spaceBtwSection),

                  // Cinematic videos
                  FVSectionHeading(
                    title: 'Video Cinematic',
                    showActionButton: false,
                  ),
                  SizedBox(height: FVSizes.spaceBtwItems),

                  // Displaying videos based on videoUrls
                  if (videoUrls.isNotEmpty)
                    ...videoUrls.map((videoUrl) {
                      return GestureDetector(
                        onTap: () {
                          print('Playing video: $videoUrl');
                          VideoPlayerController videoPlayerController =
                              VideoPlayerController.network(videoUrl);
                          ChewieController chewieController = ChewieController(
                            videoPlayerController: videoPlayerController,
                            aspectRatio: 6 / 9, // Sesuaikan dengan rasio aspek video Anda
                            autoInitialize: true,
                            looping:
                                false, // Atur true jika ingin video di-loop
                            errorBuilder: (context, errorMessage) {
                              return Center(
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          );
                          Get.to(() => Chewie(controller: chewieController));
                        },
                        child: ListTile(
                          title: Text('Video Cinematic'),
                          leading: Icon(Iconsax.video),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
