import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/brands/brand_card.dart';
import 'package:fvapp/common/widgets/layouts/grid_layout.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/screens/brand/brand_products.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FVAppBar(title: Text('Paket'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Heading
              const FVSectionHeading(title: 'Paket', showActionButton: false),
              const SizedBox(height: FVSizes.spaceBtwItems),

              // Brands
              FVGridLayout(
                  itemCount: 10,
                  mainAxisExtent: 80,
                  itemBuilder: (context, index) => FVBrandCard(
                      showBorder: true,
                      onTap: () {}))
            ],
          ),
        ),
      ),
    );
  }
}
