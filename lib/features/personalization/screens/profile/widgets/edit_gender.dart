import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditGenderDialog extends StatefulWidget {
  final String initialGender;
  final void Function(String gender) onSave;

  EditGenderDialog({required this.initialGender, required this.onSave});

  @override
  _EditGenderDialogState createState() => _EditGenderDialogState();
}

class _EditGenderDialogState extends State<EditGenderDialog> {
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _genderController = TextEditingController(text: widget.initialGender);
  }

  @override
  void dispose() {
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Gender'),
      content: TextField(
        controller: _genderController,
        decoration: InputDecoration(labelText: 'Gender'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_genderController.text.trim());
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
