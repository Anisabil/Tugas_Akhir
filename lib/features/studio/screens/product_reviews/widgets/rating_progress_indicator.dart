import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/screens/product_reviews/widgets/progress_indicator_and_rating.dart';

class FVOverallProductRating extends StatelessWidget {
  const FVOverallProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text('4.0',
                style: Theme.of(context).textTheme.displayLarge)),
        const Expanded(
          flex: 7,
          child: Column(
            children: [
              FVRatingProgressIndicatior(text: '5', value: 1.0),
              FVRatingProgressIndicatior(text: '4', value: 0.8),
              FVRatingProgressIndicatior(text: '3', value: 0.6),
              FVRatingProgressIndicatior(text: '2', value: 0.4),
              FVRatingProgressIndicatior(text: '1', value: 0.2),
            ],
          ),
        )
      ],
    );
  }
}
