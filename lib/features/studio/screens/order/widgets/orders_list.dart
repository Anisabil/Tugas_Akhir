import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

class FVOrderListItems extends StatelessWidget {
  const FVOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      separatorBuilder: (_, __) =>
          const SizedBox(height: FVSizes.spaceBtwItems),
      itemBuilder: (_, index) => FVRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(FVSizes.md),
        backgroundColor: dark ? FVColors.dark : FVColors.light,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -- Row 1
            Row(
              children: [
                // 1 - Icon

                const Icon(Iconsax.ship),
                const SizedBox(width: FVSizes.spaceBtwItems / 2),

                // 2 - Status & Date
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proses',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: FVColors.teal, fontWeightDelta: 1),
                      ),
                      Text('25 Feb 2023',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),

                // 3 - Icon
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.arrow_right_34,
                        size: FVSizes.iconSm)),
              ],
            ),
            const SizedBox(height: FVSizes.spaceBtwItems),

            // -- Row 2
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // 1 - Icon

                      const Icon(Iconsax.tag),
                      const SizedBox(width: FVSizes.spaceBtwItems / 2),

                      // 2 - Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pesanan',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              '[#26a4y]',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      // 1 - Icon

                      const Icon(Iconsax.calendar),
                      const SizedBox(width: FVSizes.spaceBtwItems / 2),

                      // 2 - Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Pesan',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              '27 Aug 2024',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
