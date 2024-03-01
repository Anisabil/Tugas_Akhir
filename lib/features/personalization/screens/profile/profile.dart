import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/images/fv_circular_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FVAppBar(
        showBackArrow: true,
        title: Text('Profil'),
      ),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const FVCircularImage(
                      image: FVImages.user2,
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Ganti foto profil'))
                  ],
                ),
              ),

              // Details
              const SizedBox(height: FVSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: FVSizes.spaceBtwItems),

              // Heading Profile Info
              const FVSectionHeading(
                title: 'Informasi Profil',
                showActionButton: false,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),

              FVProfileMenu(
                title: 'Nama',
                value: 'Anisa Putriani',
                onPressed: () {},
              ),
              FVProfileMenu(
                title: 'Pengguna',
                value: 'anisaaa',
                onPressed: () {},
              ),

              const SizedBox(height: FVSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: FVSizes.spaceBtwItems),

              // Heading Personal Info
              const FVSectionHeading(
                title: 'Informasi Pribadi',
                showActionButton: false,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),

              FVProfileMenu(
                title: 'ID Pengguna',
                value: '2103004',
                icon: Iconsax.copy,
                onPressed: () {},
              ),
              FVProfileMenu(
                title: 'E-mail',
                value: 'anisa@gmail.com',
                onPressed: () {},
              ),
              FVProfileMenu(
                title: 'Nomor HP',
                value: '+62-831-50136170',
                onPressed: () {},
              ),
              FVProfileMenu(
                title: 'J. Kelamin',
                value: 'Perempuan',
                onPressed: () {},
              ),
              FVProfileMenu(
                title: 'Tgl. Lahir',
                value: '26 Feb, 2003',
                onPressed: () {},
              ),
              const Divider(),
              const SizedBox(height: FVSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Tutup Akun', style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
