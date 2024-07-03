import 'package:fvapp/admin/models/category_model.dart';
import 'package:fvapp/admin/service/category_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  final CategoryService _categoryService = CategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      categories.value = await _categoryService.getCategories();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<Category?> getCategoryById(String categoryId) async {
    try {
      return await _categoryService.getCategoryById(categoryId);
    } catch (e) {
      print("Error getting category by ID: $e");
      return null;
    }
  }


  void addCategory(String name) async {
    await _categoryService.addCategory(name);
    fetchCategories();
  }

  void updateCategory(String id, String name) async {
    await _categoryService.updateCategory(id, name);
    fetchCategories();
  }

  void deleteCategory(String id) async {
    await _categoryService.deleteCategory(id);
    fetchCategories();
  }
}
