import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class FVBillingAddressSection extends StatelessWidget {
  const FVBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FVSectionHeading(
          title: 'Alamat',
          buttonTitle: 'Ubah',
          onPressed: () {},
        ),
        Text('Anisa Ptrn', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),
        
        Row(
          children: [
            const Icon(
              Icons.phone,
              color: FVColors.grey,
              size: 16,
            ),
            const SizedBox(width: FVSizes.spaceBtwItems),
            Text('+62 831 50136170',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(
              Icons.location_history,
              color: FVColors.grey,
              size: 16,
            ),
            const SizedBox(width: FVSizes.spaceBtwItems),
            Expanded(
              child: Text(
                'Athar KaTih, Lajer 45609, IDN',
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
