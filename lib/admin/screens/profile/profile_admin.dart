import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/event/event.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/data/repositories/authentication/authentication_repository.dart';
import 'package:fvapp/features/personalization/screens/profile/profile.dart';
import 'package:fvapp/features/studio/screens/order/order.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_function.dart';

class ProfileAdmin extends StatelessWidget {
  const ProfileAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationRepository());
    final dark = FVHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            FVPrimaryHeaderContainer(
                child: Column(
              children: [
                // AppBar
                FVAppBar(
                  title: Text(
                    'Akun',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: FVColors.white),
                  ),
                ),

                // User Profile Card
                FVUserProfileTile(
                  onPressed: () => Get.to(() => const ProfileScreen()),
                ),
                const SizedBox(height: FVSizes.spaceBtwSection),
              ],
            )),

            // Body
            Padding(
              padding: const EdgeInsets.all(FVSizes.defaultSpace),
              child: Column(
                children: [
                  // Account Setting
                  const FVSectionHeading(
                    title: 'Pengaturan Akun',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: FVSizes.spaceBtwItems,
                  ),
                  
                  const FVSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Notifikasi',
                    subTitle: 'Atur segala jenis pesan notifikasi',
                  ),

                  
                  const SizedBox(height: FVSizes.spaceBtwSection * 6),

                  // Button Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => controller.logout(),
                      child: const Text(FVText.logout),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
