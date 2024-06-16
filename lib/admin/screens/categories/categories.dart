import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fvapp/admin/screens/categories/widgets/box_category.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/popups/loaders.dart';

class SettingCategories extends StatefulWidget {
  const SettingCategories({super.key});

  @override
  _SettingCategoriesState createState() => _SettingCategoriesState();
}

class _SettingCategoriesState extends State<SettingCategories> {
  final DatabaseReference _categoryRef =
      FirebaseDatabase.instance.reference().child('categories');

  void _showEditPopup(BuildContext context, String categoryKey, String initialValue) {
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
                _categoryRef.child(categoryKey).set({'name': newValue}).then((_) {
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

  void _showDeleteConfirmation(BuildContext context, String categoryKey) {
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
                _categoryRef.child(categoryKey).remove().then((_) {
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
                _categoryRef.push().set({'name': newCategoryName}).then((_) {
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
        child: StreamBuilder(
          stream: _categoryRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<String, dynamic> categories =
                  (snapshot.data!.snapshot.value as Map<dynamic, dynamic>).cast<String, dynamic>();
              return GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  String key = categories.keys.toList()[index];
                  String categoryName = categories[key]['name'];
                  return CategoryBox(
                    icon: Icons.category,
                    text: categoryName,
                    onEdit: () => _showEditPopup(context, key, categoryName),
                    onDelete: () => _showDeleteConfirmation(context, key),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
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
