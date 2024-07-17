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

  var isLoading = false.obs;

  void fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _categoryService.getCategories();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryNameById(String categoryId) {
    try {
      return categories.firstWhere((category) => category.id == categoryId).name;
    } catch (e) {
      return 'Unknown Category';
    }
  }

  void addCategory(String name, String imageUrl) async {
    await _categoryService.addCategory(name, imageUrl);
    fetchCategories();
  }

  void updateCategory(String id, String name, String imageUrl) async {
    await _categoryService.updateCategory(id, name, imageUrl);
    fetchCategories();
  }

  void deleteCategory(String id) async {
    await _categoryService.deleteCategory(id);
    fetchCategories();
  }
}
