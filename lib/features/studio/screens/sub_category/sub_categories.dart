import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/images/fv_rounded_image.dart';
import 'package:fvapp/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/texts/section_heading.dart';

class SubCategoriesScreen extends StatelessWidget {
  final Package package;

  SubCategoriesScreen({super.key, required this.package});

  final PackageController _packageController = Get.put(PackageController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(
        title: Text(package.categoryId),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Banner
              const FVRoundedImage(
                  width: double.infinity,
                  imageUrl: FVImages.banner01,
                  applyImageRadius: true),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Sub - Categories
              Column(
                children: [
                  // Heading
                  FVSectionHeading(title: 'Wedding Package', onPressed: () {}),
                  const SizedBox(height: FVSizes.spaceBtwItems / 2),

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: FVSizes.spaceBtwItems),
                      itemBuilder: (context, index) =>
                          FVProductCardHorizontal(package: _packageController.packages[index]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
