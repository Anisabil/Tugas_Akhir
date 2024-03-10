import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/screens/order/widgets/orders_list.dart';
import 'package:fvapp/utils/constants/sizes.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: FVAppBar(
        title:
            Text('Pesananku', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(FVSizes.defaultSpace),

        // Orders
        child: FVOrderListItems(),
      ),
    );
  }
}
