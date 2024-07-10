import 'package:flutter/material.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/features/studio/screens/event/controller/event_controller.dart';
import 'package:fvapp/features/studio/screens/rent/widgets/rent_form.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:fvapp/features/studio/screens/checkout/temporary_data/temporary_controller.dart';

class EventBottomNavigationBar extends StatelessWidget {
  final Package package;
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onFormSubmit;
  final Map<String, dynamic> formData;

  EventBottomNavigationBar({
  required this.package,
  required this.onNext,
  required this.onFormSubmit,
  required this.formData,
}) {
  print('EventBottomNavigationBar initialized with packageId: ${package.id}, packageName: ${package.name}');
}


  @override
  Widget build(BuildContext context) {
    final eventFormController = Get.find<EventFormController>();

    return Padding(
      padding: const EdgeInsets.all(FVSizes.defaultSpace),
      child: GetBuilder<EventFormController>(
        init: eventFormController,
        builder: (controller) {
          return ElevatedButton(
            onPressed: controller.selectedDay == null || eventFormController.isEventDay(controller.selectedDay!)
                ? () {
                    FVLoaders.errorSnackBar(
                      title: 'Error',
                      message: 'Silakan pilih tanggal terlebih dahulu atau pilih tanggal lain',
                    );
                  }
                : () {
                    formData['selectedDay'] = controller.selectedDay!;
                    formData['packageId'] = package;
print('FormData: $formData');
                    Get.to(() => RentFormScreen(
                      onNext: onNext,
                      onFormSubmit: onFormSubmit,
                      package: package,
                      selectedDay: controller.selectedDay!, // Pass selected day to the next screen
                    ));
                  },
            child: const Text('Selanjutnya'),
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.selectedDay == null || eventFormController.isEventDay(controller.selectedDay!) ? FVColors.grey : FVColors.gold,
            ),
          );
        },
      ),
    );
  }
}
