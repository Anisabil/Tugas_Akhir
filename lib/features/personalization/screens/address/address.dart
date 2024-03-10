import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/features/personalization/screens/address/widgets/single_address.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'add_new_address.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: FVColors.teal,
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        child: const Icon(
          Iconsax.add,
          color: FVColors.white,
        ),
      ),
      appBar: FVAppBar(
        showBackArrow: true,
        title: Text(
          "Alamat",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              FVSingleAddress(selectedAddress: false),
              FVSingleAddress(selectedAddress: true),
            ],
          ),
        ),
      ),
    );
  }
}
