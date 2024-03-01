import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class FVSocialButtons extends StatelessWidget {
  const FVSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: FVColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: FVSizes.iconMd,
              height: FVSizes.iconMd,
              image: AssetImage(FVImages.google),
            ),
          ),
        ),
        const SizedBox(
          width: FVSizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: FVColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: FVSizes.iconMd,
              height: FVSizes.iconMd,
              image: AssetImage(FVImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}
