import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/personalization/screens/settings/settings.dart';
import 'features/studio/screens/home/home.dart';
import 'features/studio/screens/rent/rent.dart';
import 'features/studio/screens/wishlist/wishlist.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = FVHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? FVColors.black : FVColors.white,
          indicatorColor: darkMode
              ? FVColors.white.withOpacity(0.1)
              : FVColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Beranda'),
            NavigationDestination(
                icon: Icon(Iconsax.menu_board), label: 'Sewa'),
            NavigationDestination(
                icon: Icon(Iconsax.gallery_favorite), label: 'favorit'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profil'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const RentScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];
}
