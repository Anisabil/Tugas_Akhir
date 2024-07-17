import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/category_model.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory(String name, String imageUrl) async {
    await _categoryCollection.add({'name': name, 'imageUrl': imageUrl});
  }

  Future<void> updateCategory(String id, String name, String imageUrl) async {
    await _categoryCollection.doc(id).update({'name': name, 'imageUrl': imageUrl});
  }

  Future<void> deleteCategory(String id) async {
    await _categoryCollection.doc(id).delete();
  }

  Future<List<Category>> getCategories() async {
    QuerySnapshot querySnapshot = await _categoryCollection.get();
    List<Category> categories = querySnapshot.docs
        .map((doc) => Category.fromSnapshot(doc))
        .toList();
    return categories;
  }
}
