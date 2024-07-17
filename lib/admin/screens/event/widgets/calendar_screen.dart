import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/admin/models/event_model.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:fvapp/admin/service/event_service.dart';
import 'package:fvapp/utils/constants/colors.dart';

class CalendarScreen extends StatefulWidget {
  final String rentId;

  CalendarScreen({Key? key, required this.rentId}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final EventController _eventController = Get.put(EventController());
  final EventService _eventService = EventService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _eventController.fetchEvents();
    _fetchRents();
  }

  Future<void> _fetchRents() async {
    try {
      List<Rent> rents = await _eventService.fetchRents();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching rents: $e');
      setState(() {
        _isLoading = false;
      });
    }
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

    if (_selectedDay.isBefore(DateTime.now())) {
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Tidak dapat membuat jadwal pada tanggal yang sudah berlalu',
      );
      return;
    }

    if (_getEventsForDay(_selectedDay).isNotEmpty) {
      FVLoaders.errorSnackBar(
        title: 'Error',
        message: 'Hanya dapat membuat satu jadwal dalam satu tanggal',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Jadwal'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nama Jadwal'),
                    onSaved: (value) => eventName = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan masukkan nama acara';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                    onSaved: (value) => description = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan masukkan deskripsi acara';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                    rentId: widget.rentId, // Use rentId from widget
                  );
                  _eventController.addEvent(newEvent);
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Success',
                    message: 'Event added successfully',
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
    String selectedRentId = event.rentId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: eventName,
                    decoration: InputDecoration(labelText: 'Event Name'),
                    onSaved: (value) => eventName = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an event name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: description,
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) => description = value ?? '',
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
                    rentId: selectedRentId,
                  );
                  _eventController.editEvent(updatedEvent);
                  Navigator.of(context).pop();
                  FVLoaders.successSnackBar(
                    title: 'Success',
                    message: 'Event updated successfully',
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(String eventId) {
    _eventController.deleteEvent(eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
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
              markerDecoration: BoxDecoration(
                color: FVColors.gold,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              var events = _eventController.events
                  .where((event) => isSameDay(event.date, _selectedDay))
                  .toList();
              if (events.isEmpty) {
                return Center(child: Text('No events for selected day.'));
              }
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ListTile(
                    title: Text(event.eventName),
                    subtitle: Text(event.description),
                    onTap: () => _editEvent(event),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteEvent(event.eventId),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
