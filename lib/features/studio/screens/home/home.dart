import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/package_controller.dart';
import 'package:fvapp/admin/controllers/promo_controller.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/admin/models/promo_model.dart';
import 'package:fvapp/admin/screens/rent_order/rent_order.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:fvapp/common/widgets/layouts/grid_layout.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:fvapp/features/studio/chat/chat.dart';
import 'package:fvapp/features/studio/screens/all_products/all_products.dart';
import 'package:fvapp/features/studio/screens/home/widgets/home_appbar.dart';
import 'package:fvapp/features/studio/screens/home/widgets/home_categories.dart';
import 'package:fvapp/features/studio/screens/home/widgets/promo_slide.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/products/product_cards/product_card_vertical.dart';

class HomeScreen extends StatelessWidget {
  final Package package;

  HomeScreen({required this.package});

  final PackageController _packageController = Get.find(); // Gunakan Get.find() untuk mengambil instance PackageController
  final PromoController _promoController = Get.put(PromoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FVPrimaryHeaderContainer(
              child: Column(
                children: [
                  FVHomeAppBar(),
                  SizedBox(height: FVSizes.spaceBtwItems),

                  // Search bar
                  FVSearchContainer(
                    text: 'Cari Paket',
                  ),
                  SizedBox(height: FVSizes.spaceBtwItems),

                  // Categories
                  Padding(
                    padding: EdgeInsets.only(left: FVSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Heading
                        FVSectionHeading(
                          title: 'Kategori',
                          showActionButton: false,
                          textColor: FVColors.white,
                        ),
                        SizedBox(height: FVSizes.spaceBtwItems),

                        // Categories
                        FVHomeCategories(packages: _packageController.packages),
                      ],
                    ),
                  ),
                  SizedBox(height: FVSizes.spaceBtwSection),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(FVSizes.defaultSpace),
              child: Column(
                children: [
                  StreamBuilder<List<PromoImage>>(
                    stream: _promoController.getImages(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<PromoImage> promoImages = snapshot.data ?? [];

                      if (promoImages.isEmpty) {
                        return Center(child: Text('No promo images available.'));
                      }

                      return FVPromoSlide(
                        banners: promoImages.map((image) => image.imageUrl).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: FVSizes.spaceBtwSection),

                  // Heading
                  FVSectionHeading(
                    title: 'Paket Tersedia',
                    onPressed: () => Get.to(() => AllProducts()),
                  ),
                  const SizedBox(height: FVSizes.spaceBtwItems),

                  // Popular Products
                  Obx(
                    () => _packageController.packages.isEmpty
                        ? const CircularProgressIndicator()
                        : FVGridLayout(
                            itemCount: _packageController.packages.length,
                            itemBuilder: (_, index) =>
                                FVProductCardVertical(
                              package: _packageController.packages[index],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            UserModel userModel = await getCurrentUser();
            if (userModel.role == 'admin' || userModel.role == 'client') {
              Get.to(() => ChatScreen(
                  receiverId: 'admin')); // Gunakan 'admin' sebagai ID fotografer
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Anda tidak memiliki akses ke fitur ini.')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          }
        },
        child: const Icon(Iconsax.messages, color: Colors.white),
        backgroundColor: FVColors.gold,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
