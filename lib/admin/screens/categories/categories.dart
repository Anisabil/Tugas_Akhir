import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fvapp/admin/screens/categories/widgets/box_category.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/popups/loaders.dart';

class SettingCategories extends StatelessWidget {
  final CollectionReference _categoryRef =
      FirebaseFirestore.instance.collection('categories');

  void _showEditPopup(BuildContext context, String categoryId, String initialValue) {
    TextEditingController _controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Kategori'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Masukkan nama kategori'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                String newValue = _controller.text;
                _categoryRef.doc(categoryId).update({'name': newValue}).then((_) {
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Kategori Berhasil Diperbaharui',
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Kategori'),
          content: Text('Apakah Anda yakin menghapus kategori ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                _categoryRef.doc(categoryId).delete().then((_) {
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Kategori Berhasil Dihapus',
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryPopup(BuildContext context) {
    String newCategoryName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Kategori'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Masukkan kategori'),
            onChanged: (value) {
              newCategoryName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                _categoryRef.add({'name': newCategoryName}).then((_) {
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Kategori Berhasil Ditambahkan',
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _categoryRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot> categories = snapshot.data!.docs;
            return GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                String categoryId = categories[index].id;
                String categoryName = categories[index]['name'];
                return CategoryBox(
                  icon: Iconsax.category,
                  text: categoryName,
                  onEdit: () => _showEditPopup(context, categoryId, categoryName),
                  onDelete: () => _showDeleteConfirmation(context, categoryId),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryPopup(context),
        child: Icon(Iconsax.add),
        tooltip: 'Tambah Kategori',
        backgroundColor: FVColors.gold,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
