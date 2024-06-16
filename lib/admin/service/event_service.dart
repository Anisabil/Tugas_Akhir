import 'package:firebase_database/firebase_database.dart';
import 'package:fvapp/admin/models/event_model.dart';

class EventService {
  final DatabaseReference _eventsRef = FirebaseDatabase.instance.ref().child('events');

  Future<List<Event>?> fetchEvents() async {
    try {
      final DataSnapshot snapshot = await _eventsRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.entries.map((entry) {
          return Event.fromJson({...entry.value, 'eventId': entry.key});
        }).toList();
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
    return null;
  }

  Future<void> addEvent(Event event) async {
    try {
      await _eventsRef.push().set(event.toJson());
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<void> editEvent(Event event) async {
    try {
      await _eventsRef.child(event.eventId).set(event.toJson());
    } catch (e) {
      print('Error editing event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsRef.child(eventId).remove();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
