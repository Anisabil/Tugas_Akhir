import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class FVOrderListItems extends StatelessWidget {
  final String userId;
  final RentController rentController = RentController();

  FVOrderListItems({required this.userId});

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return FutureBuilder<List<Rent>>(
      future: rentController.getRentsByUserId(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada riwayat sewa.'));
        }

        final rents = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: rents.length,
          separatorBuilder: (_, __) => const SizedBox(height: FVSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final rent = rents[index];
            return FVRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(FVSizes.md),
              backgroundColor: dark ? FVColors.dark : FVColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -- Row 1
                  Row(
                    children: [
                      const Icon(Iconsax.ship),
                      const SizedBox(width: FVSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rent.status, // Pastikan status ditampilkan di sini
                              style: Theme.of(context).textTheme.bodyLarge!.apply(
                                    color: FVColors.gold,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                            Text(
                              rent.packageName,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.arrow_right_34, size: FVSizes.iconSm),
                      ),
                    ],
                  ),
                  const SizedBox(height: FVSizes.spaceBtwItems),
                  // -- Row 2
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.tag),
                            const SizedBox(width: FVSizes.spaceBtwItems / 2),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sewa',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    rent.theme,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: FVSizes.spaceBtwItems / 2),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Pilihan',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(rent.date),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
