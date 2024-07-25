import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan ini untuk menggunakan Clipboard
import 'package:fvapp/admin/controllers/bank_controller.dart';
import 'package:fvapp/admin/models/bank_model.dart';
import 'package:fvapp/utils/popups/loaders.dart'; // Pastikan file ini sudah ada
import 'package:get/get.dart';
import 'package:fvapp/features/studio/screens/biodata/biodata_form.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/features/studio/screens/invoice/invoice.dart';
import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class OrderDetail extends StatelessWidget {
  final String rentId;

  OrderDetail({Key? key, required this.rentId}) : super(key: key);

  final RentController rentController = Get.put(RentController());
  final BankController bankController = Get.find(); // Mengambil instance BankController yang sudah ada

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rentController.loadRentDetail(rentId);
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Detail Sewa'),
        actions: [
          Obx(() {
            if (rentController.rent.value != null) {
              Rent rent = rentController.rent.value!;
              if (rent.status == 'Belum Bayar') {
                return IconButton(
                  icon: Icon(Iconsax.document_download, color: Colors.grey),
                  onPressed: () {
                    FVLoaders.errorSnackBar(
                      title: 'Belum ada pembayaran',
                      message: 'Anda belum melakukan pembayaran, konfirmasi kepada admin jika Anda sudah membayar'
                    );
                  },
                );
              } else if (rent.status == 'Belum Lunas' || rent.status == 'Lunas') {
                return IconButton(
                  icon: Icon(Iconsax.document_download),
                  onPressed: () async {
                    try {
                      Uint8List pdfData = await InvoicePdf().generateInvoicePDF(rent);

                      final directory = await getExternalStorageDirectory();
                      final fileName = "${rent.id}_${DateTime.now().millisecondsSinceEpoch}.pdf";
                      final filePath = "${directory!.path}/$fileName";
                      final file = await File(filePath).writeAsBytes(pdfData);

                      await OpenFile.open(file.path);
                    } catch (e) {
                      FVLoaders.errorSnackBar(
                        title: 'Error',
                        message: 'Gagal memuat Invoice'
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
        if (rentController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (rentController.rent.value == null) {
          return Center(child: Text('Tidak ada detail sewa yang tersedia'));
        }

        Rent rent = rentController.rent.value!;
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
                        SizedBox(height: FVSizes.spaceBtwSection),
                        Text('Pembayaran bisa melalui:'),
                        SizedBox(height: FVSizes.spaceBtwItems),
                        Obx(() {
                          Bank? bank = bankController.selectedBank.value;
                          return bank != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Rekening ${bank.bankName}'),
                                    SizedBox(height: FVSizes.spaceBtwItems / 2),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: bank.accountNumber));
                                        FVLoaders.successSnackBar(
                                          title: 'Berhasil',
                                          message: 'Nomor rekening berhasil disalin' 
                                        );
                                      },
                                      child: Text(
                                        '${bank.accountNumber}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: FVSizes.spaceBtwItems / 2),
                                    Text('A/N ${bank.accountName}'),
                                  ],
                                )
                              : Text('Pilih metode pembayaran');
                        }),
                        SizedBox(height: FVSizes.spaceBtwSection),
                        GestureDetector(
                          onTap: () {
                            if (rent.status == 'Belum Bayar') {
                              FVLoaders.errorSnackBar(
                                title: 'Belum ada pembayaran',
                                message: 'Anda belum melakukan pembayaran, konfirmasi kepada admin jika Anda sudah membayar'
                              );
                            } else {
                              Get.to(() => BiodataScreen(
                                    biodataId: rent.biodataId,
                                    userId: rent.userId,
                                    rentId: rent.id,
                                  ));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Isi Form Biodata',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: rent.status == 'Belum Bayar'
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: rent.status == 'Belum Bayar'
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ],
                          ),
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
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus data sewa ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      rentController.deleteRent(rentId);
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
}
