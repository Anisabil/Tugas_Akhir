import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/bank_model.dart';
import 'package:iconsax/iconsax.dart';

class AddBankAccountModal extends StatefulWidget {
  final Function(Bank) onSave;
  final Bank? bank;

  AddBankAccountModal({required this.onSave, this.bank});

  @override
  _AddBankAccountModalState createState() => _AddBankAccountModalState();
}

class _AddBankAccountModalState extends State<AddBankAccountModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bank != null) {
      _bankNameController.text = widget.bank!.bankName;
      _accountNumberController.text = widget.bank!.accountNumber;
      _accountNameController.text = widget.bank!.accountName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.bank == null ? 'Tambah Akun Bank Baru' : 'Edit Akun Bank'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.bank),
                  labelText: 'Nama Bank',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Bank harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.card),
                  labelText: 'Nomor Rekening',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Rekening harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: 'Nama Pemilik Akun',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Pemilik Akun harus diisi';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final bank = Bank(
                id: widget.bank?.id ?? '',
                bankName: _bankNameController.text,
                accountName: _accountNameController.text,
                accountNumber: _accountNumberController.text,
              );
              widget.onSave(bank);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
