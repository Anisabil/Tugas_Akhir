import 'package:flutter/material.dart';

class EditBirthdateDialog extends StatefulWidget {
  final String initialBirthdate;
  final Function(String) onSave;

  const EditBirthdateDialog({
    Key? key,
    required this.initialBirthdate,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditBirthdateDialogState createState() => _EditBirthdateDialogState();
}

class _EditBirthdateDialogState extends State<EditBirthdateDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialBirthdate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Tanggal Lahir'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Tanggal Lahir (DD/MM/YYYY)',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Batal'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Simpan'),
          onPressed: () {
            final newBirthdate = _controller.text;
            widget.onSave(newBirthdate);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
