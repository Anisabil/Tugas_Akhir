import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/layouts/grid_layout.dart';
import 'package:fvapp/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class FVCategoryTab extends StatelessWidget {
  const FVCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Brands
              const FVBrandShowcase(
                images: [FVImages.contoh1, FVImages.contoh2, FVImages.contoh3],
              ),
              const FVBrandShowcase(
                images: [FVImages.contoh1, FVImages.contoh2, FVImages.contoh3],
              ),
              const SizedBox(
                height: FVSizes.spaceBtwItems,
              ),

              // Products
              FVSectionHeading(
                title: 'Pilihan Lain',
                onPressed: () {},
              ),
              const SizedBox(
                height: FVSizes.spaceBtwItems,
              ),

              FVGridLayout(
                itemCount: 4,
                itemBuilder: (_, index) => const FVProductCardVertical(),
              ),
              const SizedBox(
                height: FVSizes.spaceBtwSection,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
