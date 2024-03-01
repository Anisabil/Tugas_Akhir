import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/images/fv_circular_image.dart';
import '../../../../common/widgets/texts/fv_brand_title_with_verified_icon.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';

class FVBrandCard extends StatelessWidget {
  const FVBrandCard({
    super.key,
    required this.showBorder,
    this.onTap,
  });

  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = FVHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: FVRoundedContainer(
        padding: const EdgeInsets.all(FVSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Flexible(
              child: FVCircularImage(
                isNetworkImage: false,
                image: FVImages.iconPreWedding,
                backgroundColor: Colors.transparent,
                overlayColor: isDark ? FVColors.white : FVColors.black,
              ),
            ),
            const SizedBox(width: FVSizes.spaceBtwItems / 2),

            // Text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FVBrandTitleWithVerifiedIcon(
                      title: 'Wedding', brandTextSize: TextSizes.large),
                  Text(
                    '500 rent',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
