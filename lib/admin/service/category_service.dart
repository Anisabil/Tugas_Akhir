import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/category_model.dart';

class CategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory(String name) async {
    await _categoryCollection.add({'name': name});
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      DocumentSnapshot snapshot = await _categoryCollection.doc(id).get();
      if (snapshot.exists) {
        return Category.fromSnapshot(snapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting category by id: $e');
      return null;
    }
  }

  Future<void> updateCategory(String id, String name) async {
    await _categoryCollection.doc(id).update({'name': name});
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
