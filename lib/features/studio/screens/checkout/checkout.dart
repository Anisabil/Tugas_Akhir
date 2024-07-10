import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:get/get.dart';

import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/products/cart/cart_item.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/personalization/controllers/user_controller.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/midtrans.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/features/studio/screens/cart/widgets/cart_items.dart';
import 'package:fvapp/features/studio/screens/checkout/SuccessCheckoutScreen.dart';
import 'package:fvapp/features/studio/screens/checkout/webview.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_address_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_payment_section.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/generate_qr_code.dart';
import 'package:fvapp/features/studio/screens/multi_step_form/multi_step_form.dart';
import 'package:fvapp/features/studio/screens/order/widgets/order_detail.dart';
import 'package:fvapp/navigation_menu.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/image_strings.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:fvapp/utils/popups/full_screen_loader.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onPrevious;
  final int currentStep;
  final RentController rentController = Get.find<RentController>();
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

    final String selectedPackageImageUrl =
        formData['selectedPackageImageUrl'] ?? '';
    final String selectedPackageCategory =
        formData['selectedPackageCategory'] ?? '';
    final String selectedPackageName = formData['selectedPackageName'] ?? '';

    final DateTime selectedDay = formData['selectedDay'] ?? DateTime.now();
    final String formattedSelectedDay =
        DateFormat('dd MMMM yyyy').format(selectedDay);

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
                    Text('Pembayaran: ${formData['selectedPembayaran'] ?? ''}',
                        style: Theme.of(context).textTheme.bodyMedium),
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
                    FVBillingAddressSection(formData: formData),
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
            FVFullScreenLoader.openLoadingDialog('Sedang Di Proses...', FVImages.loadingIlustration);

            try {
              // Ambil data pengguna
              final user = await userController.getUserData();
              if (user == null) {
                throw Exception('Failed to get user data');
              }

              // Ambil package dari formData
              final Package? package = formData['package'] as Package?;
              if (package == null || package.id.isEmpty || package.name.isEmpty) {
                throw Exception('Package ID or name is invalid');
              }

              // Tambahkan packageId dan packageName ke formData
              formData['packageId'] = package.id;
              formData['packageName'] = package.name;
              formData['userName'] = user.userName;
              formData['clientEmail'] = user.email;

              // Debug print untuk formData
              print('FormData: $formData');

              // Periksa validitas data
              if (formData['packageId'] == null || formData['price'] == null) {
                throw Exception('Form data is incomplete');
              }

              // Generate QR code data
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
                status: 'Belum Bayar',
                email: user.email,
              );

              // Simpan data sewa
              await rentController.addRent(rent);

              // Generate QR Code untuk pembayaran
              final qrCodeData = await rentController.generateQRCodeForPayment(rent);

              // Tampilkan pesan sukses
              FVFullScreenLoader.stopLoading();
              Get.to(() => SuccessCheckoutScreen(
                rentId: rent.id,
                image: FVImages.successIlustration,
                title: 'Pemesanan Berhasil',
                subTitle: 'Terima kasih telah melakukan pemesanan. Anda dapat melihat QR Code pembayaran di riwayat sewa.',
              ));
            } catch (error) {
              print('Error: $error'); // Log error untuk debugging
              FVFullScreenLoader.stopLoading();
              FVLoaders.errorSnackBar(
                title: 'Error!',
                message: 'Terjadi Kesalahan: $error',
              );
            }
          },
          child: Text('Lanjutkan Pembayaran'),
        ),
      ),
    );
  }
}
