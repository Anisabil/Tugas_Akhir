import 'package:flutter/material.dart';
import 'package:fvapp/admin/screens/event/widgets/calendar_screen.dart';
import 'package:fvapp/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:fvapp/admin/controllers/rent_detail_controller.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/common/widgets/texts/section_heading.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/features/studio/screens/checkout/widgets/billing_amount_section.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';

class RentDetail extends StatelessWidget {
  final String rentId;

  RentDetail({Key? key, required this.rentId}) : super(key: key);

  final RentDetailController controller = Get.put(RentDetailController());

  @override
  Widget build(BuildContext context) {
    controller.loadRentDetail(rentId);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Detail Sewa',
        ),
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

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: FVSizes.spaceBtwSection),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: rent.status == 'Belum Bayar'
                                ? () {
                                    controller.setStatus('Belum Lunas');
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rent.status == 'Belum Bayar' ? FVColors.gold : FVColors.grey,
                            ),
                            child: Text('Belum Lunas', style: TextStyle(color: FVColors.softGrey)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: rent.status == 'Belum Lunas'
                                ? () {
                                    controller.setStatus('Lunas');
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rent.status == 'Belum Lunas' ? FVColors.gold : FVColors.grey,
                            ),
                            child: Text('Lunas', style: TextStyle(color: FVColors.softGrey),),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FVSizes.spaceBtwItems),
                    FVSettingsMenuTile(
                      icon: Iconsax.calendar,
                      title: 'Jadwalkan',
                      subTitle: 'Buat jadwal event',
                      onTap: () {
                        Get.to(() => CalendarScreen(rentId: rentId)); // Mengirim rentId ke CalendarScreen
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(FVSizes.defaultSpace),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, rentId, controller);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FVColors.error,
                  ),
                  child: Text('Hapus Sewa'),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String rentId, RentDetailController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data sewa ini?'),
          actions: <Widget>[
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
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
