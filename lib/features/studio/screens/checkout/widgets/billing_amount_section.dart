import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class FVBillingAmountSection extends StatelessWidget {
  const FVBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SubtTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rp246',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),

        // Shipping free
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gratis Pengiriman',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rp6.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),

        // Tax Free
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bebas Pajak',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rp6.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),

        // Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jumlah Pesanan',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rp6.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
