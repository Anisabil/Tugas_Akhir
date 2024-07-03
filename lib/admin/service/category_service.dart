import 'package:firebase_database/firebase_database.dart';
import 'package:fvapp/admin/models/category_model.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('categories');
  final Uuid _uuid = Uuid();

  Future<void> addCategory(String name) async {
    String id = _uuid.v4();
    Category category = Category(id: id, name: name);
    await _dbRef.child(id).set(category.toJson());
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      // Gunakan await dan then untuk mendapatkan DataSnapshot dari DatabaseEvent
      DataSnapshot snapshot = await _dbRef.child(id).once().then((event) => event.snapshot);

      // Pastikan snapshot.value bukan null sebelum mengonversi ke Map
      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return Category.fromJson(Map<String, dynamic>.from(data));
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting category by id: $e');
      return null;
    }
  }

  Future<void> updateCategory(String id, String name) async {
    await _dbRef.child(id).update({'name': name});
  }

  Future<void> deleteCategory(String id) async {
    await _dbRef.child(id).remove();
  }

  Future<List<Category>> getCategories() async {
    DataSnapshot snapshot = await _dbRef.once().then((event) => event.snapshot);
    List<Category> categories = [];
    if (snapshot.value != null) {
      Map<dynamic, dynamic> categoryMap = snapshot.value as Map<dynamic, dynamic>;
      categoryMap.forEach((key, value) {
        categories.add(Category.fromJson(Map<String, dynamic>.from(value)));
      });
    }
    return categories;
  }
}
