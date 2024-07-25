import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/bank_controller.dart';
import 'package:fvapp/admin/models/bank_model.dart';
import 'package:fvapp/admin/screens/bank/add_bank_account.dart';
import 'package:fvapp/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FVSingleBank extends StatelessWidget {
  final Bank bank;
  FVSingleBank({
    required this.bank,
  });

  final BankController bankController = Get.find();

  @override
  Widget build(BuildContext context) {
    final dark = FVHelperFunctions.isDarkMode(context);

    return Obx(() {
      bool selectedBankAccount = bank.id == bankController.selectedBankId.value;

      return FVRoundedContainer(
        padding: const EdgeInsets.all(FVSizes.md),
        width: double.infinity,
        showBorder: true,
        backgroundColor: selectedBankAccount
            ? FVColors.gold.withOpacity(0.5)
            : Colors.transparent,
        borderColor: selectedBankAccount
            ? Colors.transparent
            : dark
                ? FVColors.darkerGrey
                : FVColors.grey,
        margin: const EdgeInsets.only(
          bottom: FVSizes.spaceBtwItems,
          left: FVSizes.lg,
          right: FVSizes.lg,
        ),
        child: GestureDetector(
          onTap: () {
            print('Bank ${bank.bankName} tapped');
            bankController.updateSelectedBank(bank.id); // Update the selected bank ID
          },
          child: Stack(
            children: [
              if (selectedBankAccount)
                Positioned(
                  right: 5,
                  top: 0,
                  child: Icon(
                    Iconsax.tick_circle5,
                    color: dark ? FVColors.light : FVColors.dark,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank.bankName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: FVSizes.sm / 2),
                  Text(
                    bank.accountNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: FVSizes.sm / 2),
                  Text(
                    bank.accountName,
                    softWrap: true,
                  ),
                ],
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddBankAccountModal(
                            onSave: (Bank updatedBank) {
                              bankController.updateBank(updatedBank);
                            },
                            bank: bank,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.trash),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Konfirmasi Penghapusan'),
                            content: const Text('Apakah Anda yakin ingin menghapus akun bank ini?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  bankController.deleteBank(bank.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
