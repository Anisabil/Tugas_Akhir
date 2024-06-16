import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/features/studio/screens/cart/widgets/cart_items.dart';
import 'package:fvapp/features/studio/screens/checkout/checkout.dart';
import 'package:fvapp/features/studio/screens/event/event.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  final Map<String, dynamic> selectedPackageData;

  const CartScreen({
    Key? key,
    required this.selectedPackageData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FVAppBar(
        showBackArrow: true,
        title: Text(
          'Paket Pilihan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        // child: FVCartItems(selectedPackageData: selectedPackageData),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: ElevatedButton(onPressed: () {}, child: const Text('Sewa')),
      ),
    );
  }
}
