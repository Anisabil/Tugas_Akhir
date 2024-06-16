import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/features/studio/screens/cart/widgets/cart_items.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_address_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_payment_section.dart';
import 'package:fvapp/features/studio/screens/event/widgets/event_list.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:fvapp/utils/popups/loaders.dart';

class RentDetail extends StatefulWidget {
  const RentDetail({super.key});

  @override
  _RentDetailState createState() => _RentDetailState();
}

class _RentDetailState extends State<RentDetail> {
  bool isPaidDP = true; // Status pembayaran sewa, true = Bayar DP, false = Lunas

  void _setPaymentStatus(bool dpStatus) {
    setState(() {
      isPaidDP = dpStatus;
    });

    final snackBar = FVLoaders.successSnackBar(
      title: 'Berhasil',
      message: isPaidDP ? 'Status diubah menjadi Bayar DP' : 'Status diubah menjadi Lunas',
    );

    if (snackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: FVAppBar(
        showBackArrow: true,
        title: Text(
          'Detail Sewa',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Items in Cart
              // const FVCartItems(showAddRemoveButtons: false),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Billing Section
              FVRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(FVSizes.md),
                backgroundColor: dark ? FVColors.black : FVColors.white,
                child: const Column(
                  children: [
                    // Pricing
                    // FVBillingAmountSection(),
                    SizedBox(height: FVSizes.spaceBtwItems),

                    // Divider
                    Divider(),
                    SizedBox(height: FVSizes.spaceBtwItems),

                    // Payment Method
                    FVBillingPaymentSection(),
                    SizedBox(height: FVSizes.spaceBtwItems),

                    // Address
                    // FVBillingAddressSection(),
                    SizedBox(height: FVSizes.spaceBtwItems * 2),

                    // Date
                    EventList(),
                    SizedBox(height: FVSizes.spaceBtwItems),
                  ],
                ),
              ),

              // Status Buttons
              const SizedBox(height: FVSizes.spaceBtwSection),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _setPaymentStatus(true),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Bayar DP'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPaidDP ? FVColors.gold : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: FVSizes.spaceBtwItems),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _setPaymentStatus(false),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Lunas'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isPaidDP ? FVColors.gold : Colors.grey,
                      ),
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
