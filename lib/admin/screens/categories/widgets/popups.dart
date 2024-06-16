import 'package:flutter/material.dart';

void showEditPopup(BuildContext context, String category) {
  TextEditingController controller = TextEditingController(text: category);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit Categori'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform edit action
              Navigator.of(context).pop();
            },
            child: Text('Simpan'),
          ),
        ],
      );
    },
  );
}

void showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Hapus Category'),
        content: Text('Apakah Anda yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform delete action
              Navigator.of(context).pop();
            },
            child: Text('Hapus'),
          ),
        ],
      );
    },
  );
}
