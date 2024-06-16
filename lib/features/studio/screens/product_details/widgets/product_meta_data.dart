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
  final String packageName;
  final double price;
  final String categoryId;

  const FVProductMetaData(
      {super.key,
      required this.packageName,
      required this.price,
      required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final darkMode = FVHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price and sale price
        Row(
          children: [
            FVProductPriceText(
              price: price,
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 1.5),

        // Title
        FVProductTitleText(title: packageName),
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
            FVBrandTitleWithVerifiedIcon(
              brandTextSize: TextSizes.medium, title: categoryId,
            ),
          ],
        )
      ],
    );
  }
}
