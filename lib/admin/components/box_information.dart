import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/image_strings.dart';

import '../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../common/widgets/images/fv_circular_image.dart';
import '../../common/widgets/texts/fv_brand_title_text.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/enums.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_function.dart';

class BoxInformation extends StatelessWidget {
  const BoxInformation({
    super.key, 
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    final isDark = FVHelperFunctions.isDarkMode(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: FVRoundedContainer(
          showBorder: true,
          borderColor: FVColors.darkGrey,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(FVSizes.md),
          margin: const EdgeInsets.only(bottom: FVSizes.spaceBtwItems),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              FVCircularImage(
                isNetworkImage: false,
                image: FVImages.iconCategory,
                backgroundColor: Colors.transparent,
                overlayColor: isDark ? FVColors.white : FVColors.black,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems), // Spacer
              // Title
              const FVBrandTitleText(
                  title: 'Kategori', brandTextSize: TextSizes.medium),
              const SizedBox(height: FVSizes.spaceBtwItems / 2), // Spacer
              // Price
              if (title != null)
              // Price (title digunakan jika tidak ada judul)
              Text(
                title ?? '',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
