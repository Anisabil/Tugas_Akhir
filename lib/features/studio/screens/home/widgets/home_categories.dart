import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/features/studio/screens/sub_category/sub_categories.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../utils/constants/image_strings.dart';

class FVHomeCategories extends StatelessWidget {
  final List<Package> packages;

  FVHomeCategories({
    Key? key,
    required this.packages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group packages by category name
    final Map<String, List<Package>> groupedPackages = {};
    for (var package in packages) {
      if (!groupedPackages.containsKey(package.categoryName)) {
        groupedPackages[package.categoryName] = [];
      }
      groupedPackages[package.categoryName]!.add(package);
    }

    final List<String> categoryNames = groupedPackages.keys.toList();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categoryNames.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          String categoryName = categoryNames[index];
          return FVVerticalImageText(
            image: FVImages.iconWedding,
            title: categoryName,
            onTap: () => Get.to(() => SubCategoriesScreen(
              categoryName: categoryName,
              packages: groupedPackages[categoryName]!, // Pass all packages with the same category
            )),
          );
        },
      ),
    );
  }
}
