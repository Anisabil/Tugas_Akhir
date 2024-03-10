import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class FVBillingPaymentSection extends StatelessWidget {
  const FVBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        FVSectionHeading(
          title: 'Metode Pembayaran',
          buttonTitle: 'Ubah',
          onPressed: () {},
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),
        Row(
          children: [
            FVRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? FVColors.light : FVColors.white,
              padding: const EdgeInsets.all(FVSizes.sm),
              child: const Image(
                image: AssetImage(FVImages.paypal),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: FVSizes.spaceBtwItems / 2),
            Text('Paypal', style: Theme.of(context).textTheme.bodyLarge),
          ],
        )
      ],
    );
  }
}
