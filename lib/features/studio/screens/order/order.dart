import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';

import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/screens/order/widgets/orders_list.dart';
import 'package:fvapp/utils/constants/sizes.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class OrderScreen extends StatelessWidget {
  final String userId;
  const OrderScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: FVAppBar(
        title: Text(
          'Riwayat Sewa',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(FVSizes.defaultSpace),
        // Orders
        child: FVOrderListItems(userId: userId),
      ),
    );
  }
}
