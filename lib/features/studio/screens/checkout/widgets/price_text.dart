import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FVPriceText extends StatelessWidget {
  const FVPriceText({
    Key? key,
    this.currencySign = 'Rp',
    required this.price,
    this.maxLiner = 1,
    this.isLarge = false,
    this.lineThrough = false,
  }) : super(key: key);

  final String currencySign;
  final double price;
  final int maxLiner;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    // Format the price with thousands separators
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(price);

    return Text(
      '$currencySign $formattedPrice',
      maxLines: maxLiner,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.titleMedium!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.bodyMedium!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null),
    );
  }
}
