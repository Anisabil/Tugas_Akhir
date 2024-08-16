import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventId;
  String eventName;
  DateTime date;
  String description;
  final String rentId;
  final String status;

  Event({
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.description,
    required this.rentId,
    this.status = 'pending',
  });

  Event copyWith({
    String? eventId,
    String? eventName,
    DateTime? date,
    String? description,
    String? rentId,
    String? status,
  }) {
    return Event(
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      date: date ?? this.date,
      description: description ?? this.description,
      rentId: rentId ?? this.rentId,
      status: status ?? this.status,
    );
  }

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      eventId: doc.id,
      eventName: data['eventName'] ?? '',
      date: (data['date'] is Timestamp ? (data['date'] as Timestamp).toDate() : DateTime.now()), // Konversi Timestamp
      description: data['description'] ?? '',
      rentId: data['rentId'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventName': eventName,
      'date': Timestamp.fromDate(date), // Konversi DateTime ke Timestamp
      'description': description,
      'rentId': rentId,
      'status': status,
    };
  }
}
