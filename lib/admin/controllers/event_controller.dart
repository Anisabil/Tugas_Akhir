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

  void fetchEvents() async {
    var fetchedEvents = await _eventService.fetchEvents();
    if (fetchedEvents.isNotEmpty) {
      events.assignAll(fetchedEvents);
      print('Events loaded: $events');
    } else {
      print('No events found.');
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
}
