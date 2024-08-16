import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:get/get.dart';
import 'package:fvapp/admin/service/event_service.dart';
import 'package:fvapp/admin/models/event_model.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;
  var selectedDay = DateTime.now().obs;
  final EventService _eventService = EventService();
  var rents = <Rent>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    fetchRents();
  }

  String? getEventStatus(DateTime date) {
    final event = events.firstWhereOrNull((e) => isSameDay(e.date, date));
    return event?.status;
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }

  void fetchEvents() async {
    try {
      var fetchedEvents = await _eventService.fetchEvents();
      events.assignAll(fetchedEvents);
      print('Events loaded: $events');
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  void fetchRents() async {
    try {
      List<Rent> fetchedRents = await _eventService.fetchRents();
      if (fetchedRents.isNotEmpty) {
        rents.assignAll(fetchedRents);
        print('Rents loaded: $rents');
      } else {
        print('No rents found.');
      }
    } catch (e) {
      print('Error fetching rents: $e');
    }
  }

  void setSelectedDay(DateTime day) {
    selectedDay.value = day;
  }

  Future<void> addEvent(Event event) async {
    await _eventService.addEvent(event);
    fetchEvents(); // Panggil fetchEvents() setelah menambahkan event
  }

  Future<void> editEvent(Event event) async {
    await _eventService.editEvent(event);
    fetchEvents(); // Panggil fetchEvents() setelah mengedit event
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventService.deleteEvent(eventId);
    fetchEvents(); // Panggil fetchEvents() setelah menghapus event
  }

  // Fungsi untuk mengonfirmasi aksi
  void _confirmAction(String eventId, String newStatus) async {
    Event? selectedEvent = events.firstWhereOrNull((event) => event.eventId == eventId);
    
    if (selectedEvent != null) {
      Event updatedEvent = Event(
        eventId: selectedEvent.eventId,
        eventName: selectedEvent.eventName,
        date: selectedEvent.date,
        description: selectedEvent.description,
        rentId: selectedEvent.rentId,
        status: newStatus, // Status baru
      );
      
      try {
        await editEvent(updatedEvent);
        Get.snackbar('Success', 'Event status updated successfully');
      } catch (e) {
        print('Error updating event status: $e');
        Get.snackbar('Error', 'Failed to update event status');
      }
    }
  }
}
