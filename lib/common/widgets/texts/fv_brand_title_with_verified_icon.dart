import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/texts/fv_brand_title_text.dart';
import 'package:fvapp/utils/constants/enums.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class FVBrandTitleWithVerifiedIcon extends StatelessWidget {
  const FVBrandTitleWithVerifiedIcon({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.textColor,
    this.iconColor = FVColors.teal,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FVBrandTitleText(
            title: title,
            color: textColor,
            maxLines: maxLines,
            textAlign: textAlign,
            brandTextSize: brandTextSize,
          ),
        ),
        const SizedBox(width: FVSizes.xs),
        Icon(
          Iconsax.verify5,
          color: iconColor,
          size: FVSizes.iconSs,
        ),
      ],
    );
  }
}
