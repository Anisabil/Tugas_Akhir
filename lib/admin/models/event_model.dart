import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String eventId;
  String eventName;
  DateTime date;
  String description;
  String rentId;

  Event({
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.description,
    required this.rentId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'],
      eventName: json['eventName'],
      date: (json['date'] as Timestamp).toDate(),
      description: json['description'],
      rentId: json['rentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'date': Timestamp.fromDate(date),
      'description': description,
      'rentId': rentId,
    };
  }

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      eventId: doc.id,
      eventName: data['eventName'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      rentId: data['rentId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventName': eventName,
      'date': Timestamp.fromDate(date),
      'description': description,
      'rentId': rentId,
    };
  }
}
