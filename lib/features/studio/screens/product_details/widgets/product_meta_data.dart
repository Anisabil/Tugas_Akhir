import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/images/fv_circular_image.dart';
import 'package:fvapp/common/widgets/texts/fv_brand_title_with_verified_icon.dart';
import 'package:fvapp/common/widgets/texts/product_price_text.dart';
import 'package:fvapp/common/widgets/texts/product_title_text.dart';
import 'package:fvapp/utils/constants/enums.dart';
import 'package:fvapp/utils/constants/image_strings.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class FVProductMetaData extends StatelessWidget {
  const FVProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = FVHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price and sale price
        Row(
          children: [
            // Sale tag
            FVRoundedContainer(
              radius: FVSizes.sm,
              backgroundColor: FVColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                  horizontal: FVSizes.sm, vertical: FVSizes.xs),
              child: Text(
                '25%',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: FVColors.black),
              ),
            ),
            const SizedBox(width: FVSizes.spaceBtwItems),

            // Price
            Text(
              'Rp 2.5jt',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .apply(decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(width: FVSizes.spaceBtwItems),
            const FVProductPriceText(
              price: '2jt',
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 1.5),

        // Title
        const FVProductTitleText(title: 'Engagement'),
        const SizedBox(height: FVSizes.spaceBtwItems / 1.5),

        // Stock status
        Row(
          children: [
            const FVProductTitleText(title: 'Status'),
            const SizedBox(width: FVSizes.spaceBtwItems),
            Text('Tersedia', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 1.5),

        // Brand
        Row(
          children: [
            FVCircularImage(
              image: FVImages.iconEngagement,
              width: 32,
              height: 32,
              overlayColor: darkMode ? FVColors.white : FVColors.black,
            ),
            const FVBrandTitleWithVerifiedIcon(
              title: ' Engagement',
              brandTextSize: TextSizes.medium,
            ),
          ],
        )
      ],
    );
  }
}
