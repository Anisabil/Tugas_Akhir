import 'package:fvapp/features/studio/payment/controller/rent_controller.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';

class RentDetailController extends GetxController {
  var rent = Rxn<Rent>();
  final RentController _rentController = Get.put(RentController());
  var isLoading = true.obs;

  Future<void> loadRentDetail(String rentId) async {
    try {
      isLoading(true);
      print('Loading rent details for ID: $rentId');
      Rent? fetchedRent = await _rentController.getRentById(rentId);
      if (fetchedRent != null) {
        rent.value = fetchedRent;
        print('Rent details loaded: ${fetchedRent.toMap()}');
      } else {
        Get.snackbar('Error', 'Rent details not found');
      }
    } catch (e) {
      print('Error loading rent details: $e');
      Get.snackbar('Error', 'Failed to load rent details');
    } finally {
      isLoading(false);
    }
  }

  void setStatus(String newStatus) async {
  if (rent.value != null) {
    try {
      print('Updating status for rentId: ${rent.value!.id} to $newStatus');
      await _rentController.updateRentStatus(rent.value!.id, newStatus);
      rent.value!.status = newStatus;

      final snackBar = FVLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Status diubah menjadi $newStatus',
      );

      if (snackBar != null) {
        Get.showSnackbar(snackBar);
      }

      // Refresh rent detail
      loadRentDetail(rent.value!.id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status: $e');
    }
  }
}

}
