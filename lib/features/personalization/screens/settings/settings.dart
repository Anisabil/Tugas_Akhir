import 'package:flutter/material.dart';
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
import '../address/address.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

                  // FVSettingsMenuTile(
                  //   icon: Iconsax.safe_home,
                  //   title: 'Bandung',
                  //   subTitle: 'Atur alamat',
                  //   onTap: () => Get.to(() => const UserAddressScreen()),
                  // ),
                  // const FVSettingsMenuTile(
                  //   icon: Iconsax.bag,
                  //   title: 'Keranjangku',
                  //   subTitle: 'Tambahkan, hapus paket dan pindah ke checkout',
                  // ),
                  FVSettingsMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'Riwayat Sewa',
                    subTitle: 'Status sewa sedang di proses dan selesai',
                    onTap: () => Get.to(() => const OrderScreen(userId: '1',)),
                  ),
                  const FVSettingsMenuTile(
                    icon: Iconsax.bank,
                    title: 'Akun Bank',
                    subTitle: 'Tarik saldo ke rekening bank terdaftar',
                  ),
                  // const FVSettingsMenuTile(
                  //   icon: Iconsax.discount_shape,
                  //   title: 'Kupon',
                  //   subTitle: 'Daftar kupon diskon',
                  // ),
                  const FVSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Notifikasi',
                    subTitle: 'Atur segala jenis pesan notifikasi',
                  ),
                  // const FVSettingsMenuTile(
                  //   icon: Iconsax.security_card,
                  //   title: 'Privasi Akun',
                  //   subTitle: 'Kelola data dan akun yang terhubung',
                  // ),

                  const SizedBox(height: FVSizes.spaceBtwSection),
                  FVSettingsMenuTile(
                    icon: Iconsax.location,
                    title: 'Tema',
                    subTitle: 'Tetapkan tema sesuai keinginan',
                    trailing: Switch(
                      value: false, 
                      onChanged: (value) {}
                    ),
                  ),

                  // // App Settings
                  // const SizedBox(height: FVSizes.spaceBtwSection),
                  // const FVSectionHeading(
                  //     title: 'Pengaturan Aplikasi', showActionButton: false),
                  // const SizedBox(height: FVSizes.spaceBtwItems),
                  // const FVSettingsMenuTile(
                  //     icon: Iconsax.document_upload,
                  //     title: 'Memuat Data',
                  //     subTitle: 'Unggah data ke cloud firebase Anda',
                  // ),

                  // FVSettingsMenuTile(
                  //   icon: Iconsax.location,
                  //   title: 'Geolokasi',
                  //   subTitle: 'Tetapkan rekomendasi berdasarkan lokasi',
                  //   trailing: Switch(value: true, onChanged: (value) {}),
                  // ),
                  // FVSettingsMenuTile(
                  //   icon: Iconsax.security_user,
                  //   title: 'Mode Aman',
                  //   subTitle: 'Hasil pencarian aman untuk segala usia',
                  //   trailing: Switch(value: false, onChanged: (value) {}),
                  // ),
                  // FVSettingsMenuTile(
                  //   icon: Iconsax.image,
                  //   title: 'Kualitas Gambar HD',
                  //   subTitle: 'Mengatur kualitas gambar untuk dilihat',
                  //   trailing: Switch(value: true, onChanged: (value) {}),
                  // ),
                  const SizedBox(height: FVSizes.spaceBtwSection),

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
