import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class FVCouponCode extends StatelessWidget {
  const FVCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return FVRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? FVColors.dark : FVColors.white,
      padding: const EdgeInsets.only(
          top: FVSizes.sm,
          bottom: FVSizes.sm,
          right: FVSizes.sm,
          left: FVSizes.md),
      child: Row(
        children: [
          // Textfield
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Punya kode promo? Tambahkan',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),

          // Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: dark
                    ? FVColors.white.withOpacity(0.5)
                    : FVColors.dark.withOpacity(0.5),
                backgroundColor: Colors.grey.withOpacity(0.2),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}
