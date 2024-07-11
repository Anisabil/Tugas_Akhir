import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/features/studio/screens/invoice/invoice.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatelessWidget {
  final String rentId;

  OrderDetail({Key? key, required this.rentId}) : super(key: key);

  final RentController controller = Get.put(RentController());

  @override
  Widget build(BuildContext context) {
    // Load rent detail when widget builds
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.loadRentDetail(rentId);
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Detail Sewa'),
        actions: [
          Obx(() {
            if (controller.rent.value != null) {
              Rent rent = controller.rent.value!;
              if (rent.status == 'Belum Bayar') {
                return IconButton(
                  icon: Icon(Iconsax.document_download, color: Colors.grey),
                  onPressed: () {
                    Get.snackbar(
                      'Belum ada pembayaran',
                      'Anda belum melakukan pembayaran, konfirmasi kepada admin jika Anda sudah membayar',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  },
                );
              } else if (rent.status == 'Belum Lunas' || rent.status == 'Lunas') {
                return IconButton(
                  icon: Icon(Iconsax.document_download),
                  onPressed: () async {
                    try {
                      Uint8List pdfData = await InvoicePdf().generateInvoicePDF(rent);

                      // Simpan file PDF ke penyimpanan lokal
                      final output = await getExternalStorageDirectory();
                      final fileName = "${rent.id}_${DateTime.now().millisecondsSinceEpoch}.pdf";
                      final file = File("${output!.path}/$fileName");
                      await file.writeAsBytes(pdfData);

                      // Buka file PDF menggunakan aplikasi default pada perangkat
                      await OpenFile.open(file.path);
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Gagal memuat invoice: $e',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.rent.value == null) {
          return Center(child: Text('Tidak ada detail sewa yang tersedia'));
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
                                    child: Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.deleteRent(rentId);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Ya'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FVColors.error,
                        ),
                        child: Text('Batalkan Pesanan'),
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

  void _launchQRISPayment(Uint8List qrCodeData) async {
    String qrCodeBase64 = base64Encode(qrCodeData);
    String qrisUrl = 'qris://payment?data=$qrCodeBase64';
    if (await canLaunch(qrisUrl)) {
      await launch(qrisUrl);
    } else {
      await launch('https://example.com/payment?data=$qrCodeBase64');
    }
  }
}
