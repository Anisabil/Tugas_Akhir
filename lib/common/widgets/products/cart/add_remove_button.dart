import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/icons/fv_circular_icon.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class FVProductQuantityWithAddRemoveButton extends StatelessWidget {
  const FVProductQuantityWithAddRemoveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FVCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: FVSizes.md,
          color: FVHelperFunctions.isDarkMode(context)
              ? FVColors.white
              : FVColors.black,
          backgroundColor: FVHelperFunctions.isDarkMode(context)
              ? FVColors.darkerGrey
              : FVColors.light,
        ),
        const SizedBox(width: FVSizes.spaceBtwItems),
        Text(
          '2',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: FVSizes.spaceBtwItems),
        const FVCircularIcon(
            icon: Iconsax.add,
            width: 32,
            height: 32,
            size: FVSizes.md,
            color: FVColors.white,
            backgroundColor: FVColors.teal),
      ],
    );
  }
}
