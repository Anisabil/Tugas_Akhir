import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/features/studio/screens/event/controller/event_controller.dart';
import 'package:fvapp/utils/constants/colors.dart';
import 'package:fvapp/utils/constants/sizes.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class EventForm extends StatefulWidget {
  final VoidCallback onNext;

  const EventForm({Key? key, required this.onNext}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late final ValueNotifier<DateTime> _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  final EventController eventController = Get.find<EventController>();
  final EventFormController eventFormController = Get.find<EventFormController>();

  @override
  void initState() {
    super.initState();
    _focusedDay = ValueNotifier(DateTime.now());
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    super.dispose();
  }

  bool _isWithinNextWeek(DateTime day) {
    final now = DateTime.now();
    final oneWeekFromNow = now.add(Duration(days: 7));
    return day.isAfter(now) && day.isBefore(oneWeekFromNow);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay.value,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (_isWithinNextWeek(selectedDay)) {
                FVLoaders.errorSnackBar(
                  title: 'Tanggal tidak dapat dipilih',
                  message: 'Tanggal dapat dipilih maksimal seminggu dari tanggal saat ini.',
                );
              } else {
                final isEventDay = eventFormController.isEventDay(selectedDay!);
                if (isEventDay) {
                  FVLoaders.errorSnackBar(
                    title: 'Tanggal tidak tersedia',
                    message: 'Tanggal ini sudah ada jadwal.',
                  );
                } else if (selectedDay.isBefore(DateTime.now())) {
                  FVLoaders.errorSnackBar(
                    title: 'Tanggal tidak valid',
                    message: 'Tidak bisa memilih tanggal yang sudah berlalu',
                  );
                } else {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay.value = focusedDay;
                    eventFormController.setSelectedDay(selectedDay!);
                  });
                  FVLoaders.successSnackBar(
                    title: 'Tanggal dipilih',
                    message: 'Tanggal yang dipilih adalah $selectedDay',
                  );
                  widget.onNext();
                }
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: FVColors.borderGold,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: FVColors.buttonCream,
                shape: BoxShape.circle,
              ),
              disabledTextStyle: TextStyle(color: Colors.grey), // Menandai tanggal tidak dapat dipilih
              todayTextStyle: TextStyle(color: Colors.white),
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isSelectable = !_isWithinNextWeek(day);
                
                if (!isSelectable) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Warna abu-abu untuk tanggal tidak dapat dipilih
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle().copyWith(
                        color: Colors.grey, // Warna teks untuk tanggal tidak dapat dipilih
                      ),
                    ),
                  );
                }

                final isEventDay = eventController.events.any((event) =>
                    isSameDay(event.date, day));
                
                if (isEventDay) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 79, 79, 79), width: 2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle().copyWith(
                        color: Color.fromARGB(255, 79, 79, 79),
                      ),
                    ),
                  );
                } else {
                  return null;
                }
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
