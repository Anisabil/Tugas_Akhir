import 'package:flutter/material.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FVAppBar(
        showBackArrow: true,
        title: Text('Tambah Alamat Baru'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FVSizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user), labelText: 'Nama'),
                ),
                const SizedBox(height: FVSizes.spaceBtwInputFields),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile),
                      labelText: 'Nomor Telepon'),
                ),
                const SizedBox(height: FVSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.building_31),
                            labelText: 'Jalan'),
                      ),
                    ),
                    const SizedBox(width: FVSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.code),
                            labelText: 'Kode Pos'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FVSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.building),
                            labelText: 'Kota'),
                      ),
                    ),
                    const SizedBox(width: FVSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.activity),
                            labelText: 'State'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FVSizes.spaceBtwInputFields),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.global), labelText: 'Negara'),
                ),
                const SizedBox(height: FVSizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child:
                      ElevatedButton(
                        onPressed: () {}, 
                        child: const Text('Simpan'),
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
