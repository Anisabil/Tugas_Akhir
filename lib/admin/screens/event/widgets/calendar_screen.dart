import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/admin/models/event_model.dart';
import 'package:fvapp/features/studio/payment/model/rent_model.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:fvapp/admin/service/event_service.dart';
import 'package:fvapp/utils/constants/colors.dart'; // Import file warna

class CalendarScreen extends StatefulWidget {
  final String rentId;
  final String userName;
  final String packageName;
  final String categoryName;
  final DateTime? date;
  final String viewMode;

  CalendarScreen({
    Key? key,
    required this.rentId,
    required this.userName,
    required this.packageName,
    required this.categoryName,
    this.date,
    this.viewMode = 'edit',
  }) : super(key: key);

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
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventController.fetchEvents();
    _fetchRents();

    if (widget.date != null) {
      _currentDate = widget.date!;
      _selectedDay = widget.date!;
      _focusedDay = widget.date!;
    }
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

  void _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  void _approveEvent(Event event) {
  _showConfirmationDialog(
    title: 'Konfirmasi Persetujuan',
    message: 'Apakah Anda yakin ingin menyetujui event ini?',
    onConfirm: () async {
      Event updatedEvent = event.copyWith(status: 'approved');
      await _eventController.editEvent(updatedEvent);
      FVLoaders.successSnackBar(
        title: 'Approved',
        message: 'Event berhasil di-approve',
      );
    },
  );
}

void _rejectEvent(Event event) {
  _showConfirmationDialog(
    title: 'Konfirmasi Penolakan',
    message: 'Apakah Anda yakin ingin menolak event ini?',
    onConfirm: () async {
      Event updatedEvent = event.copyWith(status: 'rejected');
      await _eventController.editEvent(updatedEvent);
      FVLoaders.errorSnackBar(
        title: 'Rejected',
        message: 'Event ditolak',
      );
    },
  );
}

void _editEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) {
        String updatedEventName = event.eventName;
        String updatedDescription = event.description;

        return AlertDialog(
          title: Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => updatedEventName = value,
                decoration: InputDecoration(labelText: 'Nama Event'),
                controller: TextEditingController(text: event.eventName),
              ),
              TextField(
                onChanged: (value) => updatedDescription = value,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                controller: TextEditingController(text: event.description),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                event.eventName = updatedEventName;
                event.description = updatedDescription;
                await _eventController.editEvent(event);
                Navigator.of(context).pop();
                FVLoaders.successSnackBar(
                  title: 'Berhasil',
                  message: 'Event berhasil diupdate',
                );
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(String eventId) {
    _showConfirmationDialog(
      title: 'Konfirmasi Penghapusan',
      message: 'Apakah Anda yakin ingin menghapus event ini?',
      onConfirm: () async {
        await _eventController.deleteEvent(eventId);
        FVLoaders.successSnackBar(
          title: 'Deleted',
          message: 'Event berhasil dihapus',
        );
      },
    );
  }

void _showAddEventDialog() {
  showDialog(
    context: context,
    builder: (context) {
      String newEventName = '';
      String newDescription = '';
      DateTime selectedDate = _eventController.selectedDay.value;

      return AlertDialog(
        title: Text('Tambah Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => newEventName = value,
              decoration: InputDecoration(labelText: 'Nama Event'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => newDescription = value,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newEventName.isNotEmpty && newDescription.isNotEmpty) {
                Event newEvent = Event(
                  eventId: DateTime.now().millisecondsSinceEpoch.toString(),
                  eventName: newEventName,
                  description: newDescription,
                  date: selectedDate,
                  rentId: '', // Sesuaikan rentId sesuai kebutuhan Anda
                );
                await _eventController.addEvent(newEvent); // Panggil controller untuk add
                Navigator.of(context).pop();
                FVLoaders.successSnackBar(
                  title: 'Berhasil',
                  message: 'Event berhasil ditambahkan',
                );
              } else {
                FVLoaders.errorSnackBar(
                  title: 'Gagal',
                  message: 'Nama event dan deskripsi tidak boleh kosong',
                );
              }
            },
            child: Text('Simpan'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: widget.viewMode == 'viewOnly'
                ? null
                : (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
            eventLoader: _getEventsForDay,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
  todayDecoration: BoxDecoration(
    color: widget.viewMode == 'viewOnly' ? Colors.transparent : FVColors.gold,
    shape: BoxShape.circle,
  ),
  selectedDecoration: BoxDecoration(
    color: FVColors.gold ,
    shape: BoxShape.circle,
  ),
  markerDecoration: BoxDecoration(
    color: widget.viewMode == 'viewOnly' ? Colors.transparent : FVColors.gold,
    shape: BoxShape.circle,
  ),
  defaultTextStyle: TextStyle(
    color: widget.viewMode == 'viewOnly' ? Colors.grey : Colors.black,
  ),
  weekendTextStyle: TextStyle(
    color: widget.viewMode == 'viewOnly' ? Colors.grey : Colors.black,
  ),
),

          ),
          Expanded(
            child: Obx(() {
              final events = _getEventsForDay(_selectedDay);
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ListTile(
                    title: Text(event.eventName),
                    subtitle: Text(event.description),
                    trailing: widget.viewMode == 'viewOnly'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_circle, color: FVColors.gold),
                                onPressed: () => _approveEvent(event),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _rejectEvent(event),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editEvent(event),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteEvent(event.eventId),
                              ),
                            ],
                          ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: widget.viewMode == 'viewOnly'
          ? null
          : FloatingActionButton(
              onPressed: _showAddEventDialog,
              backgroundColor: FVColors.gold,
              child: Icon(Icons.add),
            ),
    );
  }
}
