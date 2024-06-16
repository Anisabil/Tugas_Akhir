import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class EditPhoneNumberDialog extends StatefulWidget {
  final String initialPhoneNumber;
  final void Function(String phoneNumber) onSave;

  EditPhoneNumberDialog({
    required this.initialPhoneNumber,
    required this.onSave,
  });

  @override
  _EditPhoneNumberDialogState createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<EditPhoneNumberDialog> {
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController(text: widget.initialPhoneNumber);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Nomor HP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(labelText: 'Nomor HP'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: FVSizes.spaceBtwItems),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(
              _phoneNumberController.text.trim(),
            );
            Navigator.of(context).pop();
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
