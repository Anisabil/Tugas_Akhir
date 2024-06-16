import 'package:flutter/material.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/utils/constants/shimmer.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class FVHomeAppBar extends StatelessWidget {
  const FVHomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return FVAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FVText.homeAppbarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: FVColors.grey),
          ),
          Obx(() {
            if (userController.profileLoading.value) {
              // Display a shimmer loader while user profile is being loaded
              return const FVShimmerEffect(width: 80, height: 15);
            } else {
            return Text(
              userController.user.value.fullName ??
                  '', // Mengambil userName dari observable user
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: FVColors.white),
            );
            }
          }),
        ],
      ),
      // actions: [
      //   FVCartCounterIcon(
      //       onPressed: () {},
      //       iconColor: FVColors.white,
      //       counterBgColor: FVColors.black,
      //       counterTextColor: FVColors.white),
      // ],
    );
  }
}
