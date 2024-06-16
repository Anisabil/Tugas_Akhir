// import 'package:flutter/material.dart';
// import 'package:fvapp/admin/controllers/package_controller.dart';
// import 'package:fvapp/common/widgets/appbar/appbar.dart';
// import 'package:fvapp/common/widgets/icons/fv_circular_icon.dart';
// import 'package:fvapp/common/widgets/layouts/grid_layout.dart';
// import 'package:fvapp/common/widgets/products/product_cards/product_card_vertical.dart';
// import 'package:fvapp/features/studio/screens/home/home.dart';
// import 'package:fvapp/utils/constants/sizes.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';

// class FavouriteScreen extends StatelessWidget {
//   FavouriteScreen({super.key});

//   final PackageController _packageController = Get.put(PackageController());


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: FVAppBar(
//         title: Text(
//           'Favorit',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         actions: [
//           FVCircularIcon(
//             icon: Iconsax.add,
//             onPressed: () => Get.to(HomeScreen()),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(FVSizes.defaultSpace),
//           child: Obx(
//                     () => _packageController.packages.isEmpty
//                         ? const CircularProgressIndicator()
//                         : FVGridLayout(
//                             itemCount: _packageController.packages.length,
//                             itemBuilder: (_, index) => FVProductCardVertical(
//                               package: _packageController.packages[index],
//                             ),
//                           ),
//                   ),
//         ),
//       ),
//     );
//   }
// }
