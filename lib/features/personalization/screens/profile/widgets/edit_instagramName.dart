import 'package:flutter/material.dart';

class EditInstagramNameDialog extends StatefulWidget {
  final String initialInstagramName;
  final void Function(String instagramName) onSave;

  EditInstagramNameDialog({required this.initialInstagramName, required this.onSave});

  @override
  _EditInstagramNameDialogState createState() => _EditInstagramNameDialogState();
}

class _EditInstagramNameDialogState extends State<EditInstagramNameDialog> {
  late TextEditingController _instagramNameController;

  @override
  void initState() {
    super.initState();
    _instagramNameController = TextEditingController(text: widget.initialInstagramName);
  }

  @override
  void dispose() {
    _instagramNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Akun Instagram'),
      content: TextField(
        controller: _instagramNameController,
        decoration: InputDecoration(labelText: 'Akun Instagram'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_instagramNameController.text.trim());
            Navigator.of(context).pop();
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
