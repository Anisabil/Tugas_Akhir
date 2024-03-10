import 'package:flutter/material.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class FVHomeAppBar extends StatelessWidget {
  const FVHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FVAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FVText.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: FVColors.grey),
          ),
          Text(
            FVText.homeAppbarSubTitle,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: FVColors.white),
          ),
        ],
      ),
      actions: [
        FVCartCounterIcon(
            onPressed: () {},
            iconColor: FVColors.white,
            counterBgColor: FVColors.black,
            counterTextColor: FVColors.white),
      ],
    );
  }
}
