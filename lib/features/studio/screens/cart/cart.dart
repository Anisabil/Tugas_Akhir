import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/features/studio/screens/cart/widgets/cart_items.dart';
import 'package:fvapp/features/studio/screens/checkout/checkout.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(
        showBackArrow: true,
        title: Text(
          'Keranjang',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(FVSizes.defaultSpace),
        // Items in Cart
        child: FVCartItems(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: ElevatedButton(onPressed: () => Get.to(() => const CheckoutScreen()), child: const Text('Periksa Rp246')),
      ),
    );
  }
}
