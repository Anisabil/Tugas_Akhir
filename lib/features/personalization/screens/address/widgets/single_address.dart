import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:iconsax/iconsax.dart';

class FVSingleAddress extends StatelessWidget {
  const FVSingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return FVRoundedContainer(
      padding: const EdgeInsets.all(FVSizes.md),
      width: double.infinity,
      showBorder: true,
      backgroundColor:
          selectedAddress ? FVColors.teal.withOpacity(0.5) : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
              ? FVColors.darkerGrey
              : FVColors.grey,
      margin: const EdgeInsets.only(bottom: FVSizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? dark
                      ? FVColors.light
                      : FVColors.dark
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Athar KaTih',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: FVSizes.sm / 2),
              const Text('(+62) 831 5013',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: FVSizes.sm / 2),
              const Text(
                '14045 Polo sky, Tukdana, Indramayu, 15678, Indonesia',
                softWrap: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
