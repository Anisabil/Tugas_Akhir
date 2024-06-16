import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/texts/product_price_text.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/price_text.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class FVBillingAmountSection extends StatelessWidget {
  final double totalPrice;
  final double downPayment;
  final double remainingPayment;

  const FVBillingAmountSection({
    Key? key,
    required this.totalPrice,
    required this.downPayment,
    required this.remainingPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Total Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Harga',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            FVPriceText(
              price: totalPrice,
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),

        // Down Payment
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Uang Muka',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            FVPriceText(
              price: downPayment,
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems / 2),

        // Remaining Payment
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sisa Pembayaran',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            FVPriceText(
              price: remainingPayment,
              isLarge: true,
            ),
          ],
        ),
      ],
    );
  }
}
