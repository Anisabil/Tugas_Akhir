import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/features/studio/screens/sub_category/sub_categories.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../utils/constants/image_strings.dart';

class FVHomeCategories extends StatelessWidget {
  final Package package;
  
  const FVHomeCategories({
    super.key, required this.package,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return FVVerticalImageText(
            image: FVImages.iconWedding,
            title: 'Gold',
            onTap: () => Get.to(() => SubCategoriesScreen(package: package)),
          );
        },
      ),
    );
  }
}

