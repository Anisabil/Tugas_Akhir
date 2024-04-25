import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_function.dart';

class FVLoginHeader extends StatelessWidget {
  const FVLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(
              dark ? FVImages.lightAppLogo : FVImages.darkAppLogo),
        ),
        Text(
          FVText.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: FVSizes.sm,
        ),
        Text(
          FVText.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
