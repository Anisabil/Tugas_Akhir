import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fvapp/admin/models/event_model.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:get/get.dart';

class EventService {
  final CollectionReference _eventsRef = FirebaseFirestore.instance.collection('events');
  final CollectionReference _rentsRef = FirebaseFirestore.instance.collection('rents');
  final events = <Event>[].obs;

  Future<List<Event>> fetchEvents() async {
    List<Event> events = [];
    try {
      QuerySnapshot snapshot = await _eventsRef.get();
      for (var doc in snapshot.docs) {
        events.add(Event.fromFirestore(doc));
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
    return events;
  }

  Future<List<Rent>> fetchRents() async {
    List<Rent> rents = [];
    try {
      QuerySnapshot snapshot = await _rentsRef.get();
      print('Total rents fetched: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print('Rent data: ${doc.data()}');
        rents.add(Rent.fromFirestore(doc));
      }
      print('Rents fetched: $rents');
    } catch (e) {
      print('Error fetching rents: $e');
    }
    return rents;
  }

  Future<void> addEvent(Event event) async {
    try {
      await _eventsRef.add(event.toFirestore());
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<void> editEvent(Event event) async {
    try {
      await _eventsRef.doc(event.eventId).set(event.toFirestore());
    } catch (e) {
      print('Error editing event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsRef.doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
