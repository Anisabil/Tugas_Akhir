import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/images/fv_rounded_image.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:fvapp/common/widgets/texts/fv_brand_title_with_verified_icon.dart';
import 'package:fvapp/common/widgets/texts/product_title_text.dart';

class FVCartItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String categoryName;
  final String name;

  const FVCartItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.categoryName,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Handle error when image fails to load
              print('Error loading image: $error\n$stackTrace');
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey, // Placeholder color
              );
            },
          ),
        ),
        const SizedBox(width: FVSizes.spaceBtwItems),
        // category and name
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FVBrandTitleWithVerifiedIcon(title: categoryName),
            Flexible(
              child: FVProductTitleText(
                title: name,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
