import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/images/fv_rounded_image.dart';
import 'package:fvapp/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/texts/section_heading.dart';

class SubCategoriesScreen extends StatelessWidget {
  final String categoryName;
  final List<Package> packages;

  SubCategoriesScreen({Key? key, required this.categoryName, required this.packages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(
        title: Text(categoryName),
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
                applyImageRadius: true,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Sub - Categories
              Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: packages.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: FVSizes.spaceBtwItems),
                      itemBuilder: (context, index) =>
                          FVProductCardHorizontal(package: packages[index]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
