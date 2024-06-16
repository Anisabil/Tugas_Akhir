import 'package:flutter/material.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/edit_birthdate.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/edit_gender.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/edit_name.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/edit_phone.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/edit_username.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/images/fv_circular_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find();

    return Scaffold(
      appBar: const FVAppBar(
        showBackArrow: true,
        title: Text('Profil'),
      ),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Obx(() => Column(
            children: [
              // Profile Picture and Change Profile Picture Button
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    FVCircularImage(
                      image: controller.user.value.profilePicture.isNotEmpty
                          ? controller.user.value.profilePicture
                          : FVImages.user,
                      isNetworkImage: controller.user.value.profilePicture.isNotEmpty,
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () async {
                        await controller.pickAndUploadProfileImage();
                      },
                      child: const Text('Ganti foto profil'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: FVSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: FVSizes.spaceBtwItems),

              // Heading Profile Info
              const FVSectionHeading(
                title: 'Informasi Profil',
                showActionButton: false,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),

              // Display UserName
              FVProfileMenu(
                title: 'Nama',
                value: controller.user.value.fullName,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditNameDialog(
                        initialFirstName: controller.user.value.firstName,
                        initialLastName: controller.user.value.lastName,
                        onSave: (firstName, lastName) async {
                          final updatedUser = controller.user.value.copyWith(
                            firstName: firstName,
                            lastName: lastName,
                          );
                          await controller.updateUserData(updatedUser);
                        },
                      );
                    },
                  );
                },
              ),

              // Display User Name
              FVProfileMenu(
                title: 'Pengguna',
                value: controller.user.value.userName,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditUsernameDialog(
                        initialUsername: controller.user.value.userName,
                        onSave: (userName) async {
                          final updatedUser = controller.user.value.copyWith(
                            userName: userName,
                          );
                          await controller.updateUserData(updatedUser);
                        },
                      );
                    },
                  );
                },
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
                title: 'E-mail',
                value: controller.user.value.email,
                onPressed: () {},
              ),
              FVProfileMenu(
                title: 'Nomor HP',
                value: controller.user.value.formattedPhoneNo,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditPhoneNumberDialog(
                        initialPhoneNumber: controller.user.value.phoneNumber,
                        onSave: (phoneNumber) async {
                          final updatedUser = controller.user.value.copyWith(
                            phoneNumber: phoneNumber,
                          );
                          await controller.updateUserData(updatedUser);
                        },
                      );
                    },
                  );
                },
              ),
              FVProfileMenu(
                title: 'J. Kelamin',
                value: controller.user.value.gender, // Update to display gender
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditGenderDialog(
                          initialGender: controller.user.value.gender,
                          onSave: (gender) async {
                            final updatedUser = controller.user.value.copyWith(
                              gender: gender,
                            );
                            await controller.updateUserData(updatedUser);
                          },
                        );
                      },
                    );
                  },
              ),
              FVProfileMenu(
                title: 'Tgl. Lahir',
                value: controller.user.value.birthdate,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EditBirthdateDialog(
                            initialBirthdate: controller.user.value.birthdate,
                            onSave: (birthdate) async {
                              final updatedUser = controller.user.value.copyWith(
                                birthdate: birthdate,
                              );
                              await controller.updateUserData(updatedUser);
                            },
                          );
                        },
                      );
                    },
              ),
              const Divider(),
              const SizedBox(height: FVSizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text(
                    'Tutup Akun',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
