import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/icons/fv_circular_icon.dart';
import 'package:fvapp/features/studio/screens/event/event.dart';
import 'package:fvapp/features/studio/screens/multi_step_form/multi_step_form.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FVBottomAddToCart extends StatelessWidget {
  final Package package;

  const FVBottomAddToCart({
    
    super.key, required this.package,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: FVSizes.defaultSpace, vertical: FVSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? FVColors.darkerGrey : FVColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(FVSizes.cardRadiusLg),
          topRight: Radius.circular(FVSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(FVSizes.md),
              backgroundColor: FVColors.black,
              side: const BorderSide(color: FVColors.black),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.messages), // Ganti dengan ikon yang Anda inginkan
                SizedBox(width: 2),
                Text('Hubungi Fotografer'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => EventScreen(package: package));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(FVSizes.md),
              backgroundColor: FVColors.black,
              side: const BorderSide(color: FVColors.black),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.calendar_add),
                SizedBox(width: 5),
                Text('Sewa'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
