import 'package:flutter/material.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icons/fv_circular_icon.dart';
import '../../../../../common/widgets/images/fv_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class FVProductImageSlider extends StatelessWidget {
  const FVProductImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return FVCurvedEdgeWidget(
      child: Container(
        color: dark ? FVColors.darkerGrey : FVColors.light,
        child: Stack(
          children: [
            // Main large image
            const SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(FVSizes.productImageRadius * 2),
                child: Center(
                  child: Image(
                    image: AssetImage(FVImages.contoh3),
                  ),
                ),
              ),
            ),
            // Image slider
            Positioned(
              right: 0,
              bottom: 30,
              left: FVSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: 6,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: FVSizes.spaceBtwItems),
                  itemBuilder: (_, index) => FVRoundedImage(
                    width: 80,
                    backgroundColor: dark ? FVColors.dark : FVColors.white,
                    border: Border.all(color: FVColors.teal),
                    padding: const EdgeInsets.all(FVSizes.sm),
                    imageUrl: FVImages.contoh2,
                  ),
                ),
              ),
            ),

            // Appbar Icons
            const FVAppBar(
              showBackArrow: true,
              actions: [
                FVCircularIcon(
                  icon: Iconsax.heart5,
                  color: Colors.red,
                )
              ],
            )
          ],
        ),
      ),

      // Product details
    );
  }
}
