import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/bank_controller.dart';
import 'package:fvapp/admin/models/bank_model.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/admin/screens/bank/widgets/single_bank.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'add_bank_account.dart';

class BankAccountScreen extends StatelessWidget {
  final BankController bankController = Get.put(BankController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Accounts'),
      ),
      body: Obx(() {
        if (bankController.banks.isEmpty) {
          return Center(child: Text('No banks available.'));
        }
        return ListView.builder(
          itemCount: bankController.banks.length,
          itemBuilder: (context, index) {
            Bank bank = bankController.banks[index];
            return FVSingleBank(
              bank: bank,
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddBankAccountModal(
                onSave: (newBank) {
                  bankController.addBank(newBank);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
