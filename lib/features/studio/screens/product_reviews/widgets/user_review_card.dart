import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/products/ratings/rating_indicator.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(FVImages.reviews2),
                ),
                const SizedBox(width: FVSizes.spaceBtwItems),
                Text('Sabil BasDay',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems),

        // Review
        Row(
          children: [
            const FVRatingBarIndicator(rating: 4),
            const SizedBox(width: FVSizes.spaceBtwItems),
            Text(
              '26 Feb, 2024',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: FVSizes.spaceBtwItems),
        const ReadMoreText(
          'Aplikasi ini cukut menarik dan bermanfaat. Saya dapat mengatur dan pembelian dengan lancar. Kerja bagus!',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' lebih sedikit',
          trimCollapsedText: ' lebih banyak',
          moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: FVColors.teal,
          ),
          lessStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: FVColors.teal,
          ),
        ),
        const SizedBox(height: FVSizes.spaceBtwItems),

        // Company review
        FVRoundedContainer(
          backgroundColor: dark ? FVColors.darkerGrey : FVColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(FVSizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("FV's Rent",
                        style: Theme.of(context).textTheme.titleMedium),
                    Text("26 Feb, 2024",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: FVSizes.spaceBtwItems),
                const ReadMoreText(
                  'Aplikasi ini cukut menarik dan bermanfaat. Saya dapat mengatur dan pembelian dengan lancar. Kerja bagus!',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: ' lebih sedikit',
                  trimCollapsedText: ' lebih banyak',
                  moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: FVColors.teal,
                  ),
                  lessStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: FVColors.teal,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: FVSizes.spaceBtwItems),
      ],
    );
  }
}
