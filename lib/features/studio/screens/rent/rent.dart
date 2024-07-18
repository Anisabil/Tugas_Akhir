import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:fvapp/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/screens/brand/all_brands.dart';
import 'package:fvapp/features/studio/screens/rent/widgets/category_tab.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/brands/brand_card.dart';

class RentScreen extends StatelessWidget {
  const RentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: FVAppBar(
          title: Text(
            'Sewa',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: FVHelperFunctions.isDarkMode(context)
                    ? FVColors.black
                    : FVColors.white,
                expandedHeight: 440,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(FVSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Search bar
                      const SizedBox(height: FVSizes.spaceBtwItems),
                      const FVSearchContainer(
                        text: 'Cari Paket',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(
                        height: FVSizes.spaceBtwSection,
                      ),

                      // Featured Brands
                      FVSectionHeading(
                        title: 'Paket Unggulan',
                        onPressed: () {},
                      ),
                      const SizedBox(height: FVSizes.spaceBtwItems / 2),

                      FVGridLayout(
                        itemCount: 4,
                        mainAxisExtent: 80,
                        itemBuilder: (_, index) {
                          return const FVBrandCard(showBorder: true);
                        },
                      )
                    ],
                  ),
                ),

                // Tabs
                bottom: const FVTabBar(
                  tabs: [
                    Tab(
                      child: Text('Wedding'),
                    ),
                    Tab(
                      child: Text('Prewedding'),
                    ),
                    Tab(
                      child: Text('Engagement'),
                    ),
                    Tab(
                      child: Text('Siraman'),
                    ),
                    Tab(
                      child: Text('Khitan'),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              FVCategoryTab(),
              FVCategoryTab(),
              FVCategoryTab(),
              FVCategoryTab(),
              FVCategoryTab()
            ],
          ),
        ),
      ),
    );
  }
}
