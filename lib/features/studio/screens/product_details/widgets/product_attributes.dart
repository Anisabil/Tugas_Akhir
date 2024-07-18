import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/chips/choice_chip.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/texts/product_price_text.dart';
import 'package:fvapp/common/widgets/texts/product_title_text.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';

class FVProductAttributes extends StatelessWidget {
  final double price;
  final String packageName;

  const FVProductAttributes({super.key, required this.price, required this.packageName});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        // Selected attribute pricing & description
        FVRoundedContainer(
          padding: const EdgeInsets.all(FVSizes.md),
          backgroundColor: dark ? FVColors.darkerGrey : FVColors.grey,
          child: Column(
            children: [
              // Title, price & description
              Row(
                children: [
                  const FVSectionHeading(
                    title: 'Note',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    width: FVSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Row(
                        children: [
                          const FVProductTitleText(
                            title: 'Paket : ',
                            smallSize: true,
                          ),
                          Text(
                            packageName,
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),

                      Row(
                        children: [
                          const FVProductTitleText(
                              title: 'Harga : ', smallSize: true),
                          // Sale Price
                          FVProductPriceText(price: price)
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Variation Decoration
              const FVProductTitleText(
                title:
                    'Sebelum sewa, harap mengikuti prosedur sewa aplikasi kami.',
                smallSize: true,
                maxLines: 4,
              )
            ],
          ),
        ),
      ],
    );
  }
}
