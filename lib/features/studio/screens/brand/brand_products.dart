import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/brands/brand_card.dart';
import 'package:fvapp/common/widgets/products/sortable/sortable_products.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(title: Text('Wedding')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Brand Detail
              FVBrandCard(showBorder: true),
              SizedBox(height: FVSizes.spaceBtwSection),

              FVSortableProducts()
            ],
          ),
        ),
      ),
    );
  }
}
