import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/category_model.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/images/fv_rounded_image.dart';
import 'package:fvapp/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/controllers/category_controller.dart';

class SubCategoriesScreen extends StatelessWidget {
  final String categoryName;
  final List<Package> packages;
  final CategoryController categoryController = Get.put(CategoryController());

  SubCategoriesScreen({Key? key, required this.categoryName, required this.packages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(
        title: Text(categoryName),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Banner
              Obx(() {
                if (categoryController.isLoading.value) {
                  return CircularProgressIndicator();
                } else {
                  final category = categoryController.categories.firstWhere(
                    (category) => category.name == categoryName,
                    orElse: () => Category(id: '', name: '', imageUrl: ''),
                  );

                  if (category.imageUrl.isEmpty) {
                    return Text('No image available');
                  } else {
                    return FVRoundedImage(
                      width: double.infinity,
                      height: 200.0,  // Atur tinggi gambar sesuai kebutuhan
                      imageUrl: category.imageUrl,
                      applyImageRadius: true,
                      isNetworkImage: true,
                    );
                  }
                }
              }),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Sub - Categories
              Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: packages.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: FVSizes.spaceBtwItems),
                      itemBuilder: (context, index) =>
                          FVProductCardHorizontal(package: packages[index]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
