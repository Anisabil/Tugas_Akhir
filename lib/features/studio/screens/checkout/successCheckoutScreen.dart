import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/admin/screens/rent_order/rent_order.dart';
import 'package:fvapp/admin/service/chat_service.dart';
import 'package:fvapp/common/styles/spacing_styles.dart';
import 'package:fvapp/features/personalization/models/user_model.dart';
import 'package:fvapp/features/studio/chat/chat.dart';
import 'package:fvapp/features/studio/screens/biodata/biodata_form.dart';
import 'package:fvapp/features/studio/screens/home/home.dart';
import 'package:fvapp/features/studio/screens/order/widgets/order_detail.dart';
import 'package:fvapp/navigation_menu.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/constants/text_strings.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SuccessCheckoutScreen extends StatelessWidget {
  final String image, title, subTitle, rentId;
  final Package package; // Tambahkan package

  SuccessCheckoutScreen({
    required this.image,
    required this.title,
    required this.subTitle,
    required this.rentId,
    required this.package, // Tambahkan package
    Key? key,
  }) : super(key: key);

  final ChatService _chatService = Get.find<ChatService>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: FVSpacingStyle.paddingWidthAppBarHeight * 2,
          child: Column(
            children: [
              // Image
              Image(
                image: AssetImage(image),
                width: FVHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwItems),

              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => OrderDetail(rentId: rentId));
                      },
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.document_text),
                          SizedBox(height: 5),
                          Text('Rincian'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: FVSizes.spaceBtwInputFields),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                          try {
              UserModel userModel = await getCurrentUser();
              if (userModel.role == 'admin' || userModel.role == 'client') {
                // Mendapatkan atau membuat chat room ID
                String chatRoomId = await _getOrCreateChatRoomId(userModel.role, 'admin'); // Ganti 'admin' dengan ID admin yang sesuai

                Get.to(() => ChatScreen(
                  roomId: chatRoomId,
                  currentUserId: userModel.id,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Anda tidak memiliki akses ke fitur ini.')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
                      },
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.messages),
                          SizedBox(height: 5),
                          Text(FVText.fvCall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Get.to(() => NavigationMenu()),
            child: const Text(FVText.fvContinue),
          ),
        ),
      ),
    );
  }
  Future<String> _getOrCreateChatRoomId(String userRole, String adminId) async {
      // Dapatkan ID pengguna saat ini
      String userId = (await getCurrentUser()).id;

      // Jika pengguna adalah client, buat atau dapatkan chat room ID dengan admin
      if (userRole == 'client') {
        return await _chatService.getOrCreateChatRoomId(adminId);
      }

      // Untuk admin, Anda mungkin ingin menangani logika lain atau menggunakan ID admin lain
      return await _chatService.getOrCreateChatRoomId(userId); // Ganti dengan ID admin jika ada
    }
}