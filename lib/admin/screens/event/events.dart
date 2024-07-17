import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/event/widgets/calendar_screen.dart';
import 'package:fvapp/admin/screens/event/widgets/event_rent_screen.dart';
import 'package:fvapp/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Events extends StatelessWidget {
  final String rentId;
  const Events({super.key, required this.rentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: Column(
          children: [
            FVSettingsMenuTile(
              icon: Iconsax.calendar,
              title: 'Kalender',
              subTitle: 'Buat jadwal event sesuai kebutuhan',
              onTap: () => Get.to(() => CalendarScreen(rentId: rentId,)),
            ),
            const SizedBox(height: FVSizes.spaceBtwItems),

            FVSettingsMenuTile(
              icon: Iconsax.note_1,
              title: 'Jadwal',
              subTitle: 'Lihat jadwal event yang tersedia',
              onTap: () => Get.to(() => EventRentScreen()),
            ),
          ],
        ),
      ),
    );
  }
}