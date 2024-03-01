import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:fvapp/common/widgets/layouts/grid_layout.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/screens/home/widgets/home_appbar.dart';
import 'package:fvapp/features/studio/screens/home/widgets/home_categories.dart';
import 'package:fvapp/features/studio/screens/home/widgets/promo_slide.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const FVPrimaryHeaderContainer(
              child: Column(
                children: [
                  FVHomeAppBar(),
                  SizedBox(height: FVSizes.spaceBtwSection),

                  // Seacrhbar
                  FVSearchContainer(
                    text: 'Cari Paket',
                  ),
                  SizedBox(height: FVSizes.spaceBtwSection),

                  //Categories
                  Padding(
                    padding: EdgeInsets.only(left: FVSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Heading
                        FVSectionHeading(
                          title: 'Kategori Terpopuler',
                          showActionButton: false,
                          textColor: FVColors.white,
                        ),
                        SizedBox(height: FVSizes.spaceBtwItems),

                        // Categories
                        FVHomeCategories()
                      ],
                    ),
                  ),
                  SizedBox(height: FVSizes.spaceBtwSection),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(FVSizes.defaultSpace),
              child: Column(
                children: [
                  const FVPromoSlide(
                    // Promo Slider
                    banners: [
                      FVImages.banner1,
                      FVImages.banner2,
                      FVImages.banner3
                    ],
                  ),
                  const SizedBox(height: FVSizes.spaceBtwSection),

                  //Heading
                  FVSectionHeading(
                    title: 'Produk Populer',
                    onPressed: () {},
                  ),
                  const SizedBox(height: FVSizes.spaceBtwItems),

                  // Popular Products
                  FVGridLayout(
                    itemCount: 4,
                    itemBuilder: (_, index) => const FVProductCardVertical(),
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
