import 'package:fvapp/admin/service/event_service.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/models/event_model.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;
  var selectedDay = DateTime.now().obs;
  final EventService _eventService = EventService();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      var fetchedEvents = await _eventService.fetchEvents();
      if (fetchedEvents != null) {
        events.value = fetchedEvents.where((event) => event != null).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch events: $e');
    }
  }

  void setSelectedDay(DateTime day) {
    selectedDay.value = day;
  }

  Future<void> addEvent(Event event) async {
    await _eventService.addEvent(event);
    fetchEvents();
  }

  Future<void> editEvent(Event event) async {
    await _eventService.editEvent(event);
    fetchEvents();
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventService.deleteEvent(eventId);
    fetchEvents();
  }
}