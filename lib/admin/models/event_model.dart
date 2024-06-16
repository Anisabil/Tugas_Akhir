class Event {
  String eventId;
  String eventName;
  DateTime date;
  String description;

  Event({
    required this.eventId,
    required this.eventName,
    required this.date,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
