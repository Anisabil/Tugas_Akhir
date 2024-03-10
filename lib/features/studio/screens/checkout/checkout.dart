import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/success_screen/success_screen.dart';
import 'package:fvapp/features/studio/screens/cart/widgets/cart_items.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_address_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_payment_section.dart';
import 'package:fvapp/navigation_menu.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/cart/coupon_widget.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: FVAppBar(
        showBackArrow: true,
        title: Text(
          'Periksa Pesanan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Items in Cart
              const FVCartItems(showAddRemoveButtons: false),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Coupon Textfield

              const FVCouponCode(),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Billing Section
              FVRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(FVSizes.md),
                backgroundColor: dark ? FVColors.black : FVColors.white,
                child: const Column(
                  children: [
                    // Pricing
                    FVBillingAmountSection(),
                    SizedBox(height: FVSizes.spaceBtwItems),

                    // Divider
                    Divider(),
                    SizedBox(height: FVSizes.spaceBtwItems),

                    // Payment Method
                    FVBillingPaymentSection(),
                    SizedBox(height: FVSizes.spaceBtwItems),

                    // Address
                    FVBillingAddressSection()
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      // Checkout Buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: ElevatedButton(
            onPressed: () => Get.to(
              () => SuccessScreen(
                  image: FVImages.successIlustration,
                  title: 'Pembayaran Berhasil',
                  subTitle: 'Fotografer akan segera menjadwalkan',
                  onPressed: () => Get.offAll(() => const NavigationMenu()),
                )),
            child: const Text('Periksa Rp246')),
      ),
    );
  }
}
