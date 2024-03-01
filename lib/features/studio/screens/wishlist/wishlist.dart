import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/icons/fv_circular_icon.dart';
import 'package:fvapp/common/widgets/layouts/grid_layout.dart';
import 'package:fvapp/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:fvapp/features/studio/screens/home/home.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(
        title: Text(
          'Favorit',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          FVCircularIcon(
            icon: Iconsax.add,
            onPressed: () => Get.to(const HomeScreen()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: FVGridLayout(
              itemCount: 6,
              itemBuilder: (_, index) => const FVProductCardVertical(),
          ),
        ),
      ),
    );
  }
}
