import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/features/studio/screens/product_reviews/widgets/progress_indicator_and_rating.dart';
import 'package:fvapp/features/studio/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:fvapp/features/studio/screens/product_reviews/widgets/user_review_card.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/products/ratings/rating_indicator.dart';
import '../../../../utils/constants/device_utility.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: const FVAppBar(
        title: Text('Reviews and Ratings'),
        showBackArrow: true,
      ),

      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Peringkat dan ulasan diverifikasi dan berasal dari acara orang - orang yang menggunakan jenis perangkat yang sama dengan yang Anda gunakan."),
              const SizedBox(height: FVSizes.spaceBtwItems),

              // overal product rating
              const FVOverallProductRating(),
              const FVRatingBarIndicator(rating: 3.5),
              Text("26.002", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // User reviews list
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
