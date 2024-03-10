import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/texts/fv_brand_title_with_verified_icon.dart';
import 'package:fvapp/common/widgets/texts/product_title_text.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/fv_rounded_image.dart';

class FVCartItem extends StatelessWidget {
  const FVCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        FVRoundedImage(
          imageUrl: FVImages.contoh3,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(FVSizes.sm),
          backgroundColor: FVHelperFunctions.isDarkMode(context)
              ? FVColors.darkerGrey
              : FVColors.light,
        ),
        const SizedBox(width: FVSizes.spaceBtwItems),

        // Title and Price
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FVBrandTitleWithVerifiedIcon(title: 'Wedding'),
            const Flexible(
                child: FVProductTitleText(
                    title: 'Wedding Package', maxLines: 1)),
            // Attributes
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Gaya ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: 'Indor ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
