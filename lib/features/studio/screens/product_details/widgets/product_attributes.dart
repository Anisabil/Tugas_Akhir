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
  const FVProductAttributes({super.key});

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
                    title: 'Variasi',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    width: FVSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const FVProductTitleText(
                              title: 'Harga : ', smallSize: true),

                          // Actual Price
                          Text(
                            'Rp 2.5jt',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: FVSizes.spaceBtwItems,
                          ),

                          // Sale Price
                          const FVProductPriceText(price: '2jt')
                        ],
                      ),

                      // Description
                      Row(
                        children: [
                          const FVProductTitleText(
                            title: 'Keterangan : ',
                            smallSize: true,
                          ),
                          Text(
                            'Tersedia',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),

              // Variation Decoration
              const FVProductTitleText(
                title:
                    'Ini deskripsi variasi, dapat diisi maksimal hingga 4 baris',
                smallSize: true,
                maxLines: 4,
              )
            ],
          ),
        ),
        const SizedBox(height: FVSizes.spaceBtwItems),

        // Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FVSectionHeading(
              title: 'Gaya',
              showActionButton: false,
            ),
            const SizedBox(height: FVSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                FVChoiceChip(
                    text: 'Teal', selected: true, onSelected: (value) {}),
                FVChoiceChip(
                    text: 'White', selected: false, onSelected: (value) {}),
                FVChoiceChip(
                    text: 'White', selected: false, onSelected: (value) {}),
              ],
            )
          ],
        ),
      ],
    );
  }
}
