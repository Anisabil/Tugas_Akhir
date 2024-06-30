import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/products/cart/cart_item.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/midtrans.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/features/studio/screens/cart/widgets/cart_items.dart';
import 'package:fvapp/features/studio/screens/checkout/SuccessCheckoutScreen.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_address_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/features/studio/screens/event/widgets/event_list.dart';
import 'package:fvapp/features/studio/screens/multi_step_form/multi_step_form.dart';
import 'package:fvapp/navigation_menu.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/cart/coupon_widget.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onPrevious;
  final int currentStep;
  final RentController rentController = RentController();
  final UserController userController = Get.put(UserController());

  CheckoutScreen({
    required this.formData,
    required this.onPrevious,
    this.currentStep = 2,
  });

  @override
  Widget build(BuildContext context) {
    final double totalPrice = formData['price'] ?? 0.0;
    final double downPayment = formData['downPayment'] ?? 0.0;
    final double remainingPayment = formData['remainingPayment'] ?? 0.0;

    final dark = FVHelperFunctions.isDarkMode(context);

    final String selectedPackageImageUrl = formData['selectedPackageImageUrl'] ?? '';
    final String selectedPackageCategory = formData['selectedPackageCategory'] ?? '';
    final String selectedPackageName = formData['selectedPackageName'] ?? '';

    final DateTime selectedDay = formData['selectedDay'] ?? DateTime.now();
    final String formattedSelectedDay = DateFormat('dd MMMM yyyy').format(selectedDay);

    return Scaffold(
      appBar: FVAppBar(
        showBackArrow: true,
        title: Text(
          'Periksa Pesanan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MultiStepFormIndicator(
                currentStep: 2,
                totalSteps: 3,
              ),
              const SizedBox(height: FVSizes.spaceBtwSection),
              FVCartItems(formData: formData),
              const SizedBox(height: FVSizes.spaceBtwSection),
              FVRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(FVSizes.md),
                backgroundColor: dark ? FVColors.black : FVColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FVBillingAmountSection(
                      totalPrice: totalPrice,
                      downPayment: downPayment,
                      remainingPayment: remainingPayment,
                    ),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    FVSectionHeading(
                      title: 'Deskripsi Sewa',
                      showActionButton: false,
                    ),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    Text('Tanggal Sewa: $formattedSelectedDay'),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    Text('Tema Acara: ${formData['selectedTema'] ?? ''}'),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    Text('Pembayaran: ${formData['selectedPembayaran'] ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    ReadMoreText(
                      'Deskripsi Tambahan: ${formData['additionalDescription'] ?? ''}',
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Lebih banyak',
                      trimExpandedText: 'Lebih sedikit',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                      lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    FVBillingAddressSection(),
                    const SizedBox(height: FVSizes.spaceBtwItems * 2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(FVSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Ambil data pengguna
              final user = await userController.getUserData();
              if (user == null) {
                throw Exception('Failed to get user data');
              }

              // Tambahkan packageId ke formData jika belum ada
              if (formData['package'] != null && formData['package'].id != null) {
                formData['packageId'] = formData['package'].id;
                formData['packageName'] = formData['package'].name;
              } else {
                throw Exception('Package ID is missing');
              }

              formData['userName'] = user.userName;

              // Debug print untuk formData
              print('FormData: $formData');

              // Periksa validitas data
              if (formData['packageId'] == null || formData['price'] == null) {
                throw Exception('Form data is incomplete');
              }

              // Buat objek Rent dari formData
              final rent = Rent(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                userId: user.id,
                userName: formData['userName'] as String,
                packageId: formData['packageId'] as String,
                packageName: formData['packageName'] as String,
                totalPrice: formData['price'] as double,
                downPayment: formData['downPayment'] as double? ?? 0.0,
                remainingPayment: formData['remainingPayment'] as double? ?? 0.0,
                date: formData['selectedDay'] as DateTime? ?? DateTime.now(),
                theme: formData['selectedTema'] as String? ?? '',
                paymentMethod: formData['selectedPembayaran'] as String? ?? '',
                description: formData['additionalDescription'] as String? ?? '',
                status: 'On Hold',
              );

              // Simpan data sewa
              await rentController.addRent(rent);

              // Proses pembayaran dengan Midtrans
              final redirectUrl = await initiateMidtransPaymentProcess(rent);
              if (redirectUrl == null || redirectUrl.isEmpty) {
                throw Exception('Failed to get Redirect URL');
              }

              // Buka URL Snap Midtrans
              await launchPaymentUrl(redirectUrl);

              // Jika pembayaran berhasil, arahkan ke SuccessCheckoutScreen
              Get.to(() => SuccessCheckoutScreen(
                image: FVImages.successIlustration, 
                title: 'Pembayaran Berhasil', 
                subTitle: 'Isi Biodata, download Invoice dan hubungi Fotografer untuk perencanaan mengabadikan momen yang lebih baik', 
                onPressed: () => Get.to(() => NavigationMenu()),
              ));
            } catch (e) {
              print('Failed to proceed to payment: $e');
              // Tambahkan penanganan kesalahan di sini
            }
          },
          child: const Text('Lanjutkan Pembayaran'),
        ),
      ),
    );
  }
  
  Future<void> launchPaymentUrl(String redirectUrl) async {
    final Uri url = Uri.parse(redirectUrl);
    print('Launching URL: $url');

    if (await canLaunch(url.toString())) {
      await launch(url.toString(), forceSafariVC: false, forceWebView: false);
    } else {
      print('Could not launch $url');
      throw Exception('Failed to launch payment URL: $url');
    }
  }
}
