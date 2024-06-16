import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/admin/models/event_model.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final EventController _eventController = Get.put(EventController());
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventController.fetchEvents();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _eventController.events
        .where((event) => isSameDay(event.date, day))
        .toList();
  }

  void _showAddEventDialog() {
    final _formKey = GlobalKey<FormState>();
    String eventName = '';
    String description = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Event Name'),
                  onSaved: (value) => eventName = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final eventId = DateTime.now().millisecondsSinceEpoch.toString();
                  final newEvent = Event(
                    eventId: eventId,
                    eventName: eventName,
                    date: _selectedDay,
                    description: description,
                  );
                  _eventController.addEvent(newEvent);
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Jadwal berhasil ditambahkan',
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editEvent(Event event) {
    final _formKey = GlobalKey<FormState>();
    String eventName = event.eventName;
    String description = event.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: eventName,
                  decoration: InputDecoration(labelText: 'Event Name'),
                  onSaved: (value) => eventName = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final updatedEvent = Event(
                    eventId: event.eventId,
                    eventName: eventName,
                    date: event.date,
                    description: description,
                  );
                  _eventController.editEvent(updatedEvent);
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Berhasil',
                    message: 'Jadwal berhasil diperbarui',
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: Obx(
        () => Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
  final now = DateTime.now();
  if (selectedDay.isBefore(now)) {
    // Tanggal yang dipilih sudah lewat
    ScaffoldMessenger.of(context).showSnackBar(
  FVLoaders.errorSnackBar(
    title: 'Error',
    message: 'Tanggal yang dipilih sudah lewat',
  ),
);
  } else {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }
},

              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: FVColors.gold,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: FVColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _getEventsForDay(_selectedDay).map((event) {
                  return ListTile(
                    title: Text(event.eventName),
                    subtitle: Text(event.description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _eventController.deleteEvent(event.eventId),
                    ),
                    onTap: () => _editEvent(event),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
            FVLoaders.errorSnackBar(
              title: 'Error',
              message: 'You cannot add an event to a past date',
            );
          } else {
            _showAddEventDialog();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: FVColors.gold,
      ),
    );
  }
}
