import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/admin/models/package_model.dart';
import 'package:fvapp/common/widgets/appbar/appbar.dart';
import 'package:fvapp/features/studio/screens/event/widgets/event_bottom_navigation_bar.dart';
import 'package:fvapp/features/studio/screens/event/widgets/event_form.dart';
import 'package:fvapp/features/studio/screens/multi_step_form/multi_step_form.dart';
import 'package:fvapp/features/studio/screens/rent/widgets/rent_form.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:get/get.dart';

class EventScreen extends StatelessWidget {
  final Package package;
  final int currentStep;

  const EventScreen({
    Key? key,
    required this.package,
    this.currentStep = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    return Scaffold(
      appBar: AppBar(title: Text('Pilih Tanggal Sewa')),
      body: Column(
        children: [
          // Tambahkan MultiStepFormIndicator di sini
          MultiStepFormIndicator(
            currentStep: currentStep,
            totalSteps: 3,
          ),
          Obx(() {
            if (eventController.events.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: EventForm(
                  onNext: () {
                    print('Tanggal telah dipilih.');
                  },
                ),
              );
            }
          }),
        ],
      ),
      bottomNavigationBar: EventBottomNavigationBar(
        package: package,
        formData: {'packageId': package.id},
        onNext: () {
          print('Tanggal telah dipilih, melanjutkan ke langkah berikutnya.');
        },
        onFormSubmit: (formData) {
          print('Data Form Sewa: $formData');
        },
      ),
    );
  }
}

