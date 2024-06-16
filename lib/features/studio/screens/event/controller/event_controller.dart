import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:get/get.dart';

class EventFormController extends GetxController {
  DateTime? selectedDay;

  void setSelectedDay(DateTime day) {
    selectedDay = day;
    update();
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
  
  bool isEventDay(DateTime day) {
    // Lakukan pengecekan dengan EventController
    final EventController eventController = Get.find<EventController>();
    return eventController.events.any((event) => isSameDay(event.date, day));
  }
}
