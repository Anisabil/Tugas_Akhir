import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class OrderDetail extends StatelessWidget {
  final String rentId;

  OrderDetail({Key? key, required this.rentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RentController controller = Get.put(RentController());

    // Load rent detail
    controller.loadRentDetail(rentId);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Detail Sewa'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.rent.value == null) {
          return Center(child: Text('No rent details available'));
        }

        Rent rent = controller.rent.value!;
        final dark = Theme.of(context).brightness == Brightness.dark;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(FVSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FVRoundedContainer(
                  showBorder: true,
                  padding: const EdgeInsets.all(FVSizes.md),
                  backgroundColor: dark ? FVColors.black : FVColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(FVSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FVSectionHeading(
                          title: 'Status ${rent.status}',
                          showActionButton: false,
                        ),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Text('Nama Klien: ${rent.userName}'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Text('Paket: ${rent.packageName}'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Text('Tanggal: ${DateFormat('dd MMMM yyyy').format(rent.date)}'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Text('Tema: ${rent.theme}'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Text('Metode Pembayaran: ${rent.paymentMethod}'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Text('Deskripsi: ${rent.description}'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        FVBillingAmountSection(
                          totalPrice: rent.totalPrice,
                          downPayment: rent.downPayment,
                          remainingPayment: rent.remainingPayment,
                        ),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        if (rent.qrCodeData != null && rent.qrCodeData!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('QR Code Pembayaran:'),
                              SizedBox(height: FVSizes.spaceBtwItems),
                              Image.memory(rent.qrCodeData!),
                              SizedBox(height: FVSizes.spaceBtwItems),
                              ElevatedButton(
                                onPressed: () {
                                  _launchQRISPayment(rent.qrCodeData!);
                                },
                                child: Text('Bayar Menggunakan QRIS'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: FVSizes.spaceBtwSection),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text('Apakah Anda yakin ingin menghapus data sewa ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.deleteRent(rentId);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                                    },
                                    child: Text('Batalkan Sewa'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FVColors.warning,
                        ),
                        child: Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _launchQRISPayment(Uint8List qrCodeData) async {
    // Konversi QR Code Data ke Base64
    String qrCodeBase64 = base64Encode(qrCodeData);

    // URL untuk membuka aplikasi pembayaran dengan QRIS
    String qrisUrl = 'qris://payment?data=$qrCodeBase64';

    // Buka aplikasi pembayaran jika tersedia, jika tidak, buka browser
    if (await canLaunch(qrisUrl)) {
      await launch(qrisUrl);
    } else {
      // Fallback: Buka browser
      await launch('https://example.com/payment?data=$qrCodeBase64');
    }
  }
}
