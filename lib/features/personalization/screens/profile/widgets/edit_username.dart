import 'package:flutter/material.dart';
import 'package:fvapp/utils/constants/sizes.dart';

class EditUsernameDialog extends StatefulWidget {
  final String initialUsername;
  final void Function(String userName) onSave;

  EditUsernameDialog({
    required this.initialUsername,
    required this.onSave,
  });

  @override
  _EditUsernameDialogState createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Username'),
      content: TextField(
        controller: _usernameController,
        decoration: InputDecoration(labelText: 'Username'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_usernameController.text.trim());
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
