import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import '../images/fv_circular_image.dart';

class FVUserProfileTile extends StatelessWidget {
  const FVUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return ListTile(
          leading: FVCircularImage(
            image: controller.user.value.profilePicture.isNotEmpty
                ? controller.user.value.profilePicture
                : FVImages.user, // Gunakan gambar default jika tidak ada gambar profil
            isNetworkImage: controller.user.value.profilePicture.isNotEmpty,
            width: 50,
            height: 50,
            padding: 0,
          ),
          title: Text(
            controller.user.value.fullName, // Ambil nilai fullName dari UserController
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: FVColors.white),
          ),
          subtitle: Text(
            controller.user.value.email, // Ambil nilai email dari UserController
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: FVColors.white),
          ),
          trailing: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Iconsax.edit,
              color: FVColors.white,
            ),
          ),
        );
      },
    );
  }
}
