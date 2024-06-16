import 'package:get/get.dart';

class TemporaryController extends GetxController {
  var selectedPackageId = ''.obs;
  var selectedPackageName = ''.obs;
  var selectedPackagePrice = 0.0.obs;
  var selectedPackageDescription = ''.obs;
  var selectedPackageCategoryId = ''.obs;

  void setPackageData({
    required String id,
    required String name,
    required double price,
    required String description,
    required String categoryId,
  }) {
    selectedPackageId.value = id;
    selectedPackageName.value = name;
    selectedPackagePrice.value = price;
    selectedPackageDescription.value = description;
    selectedPackageCategoryId.value = categoryId;
  }
}
