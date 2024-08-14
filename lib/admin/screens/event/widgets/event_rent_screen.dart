import 'package:flutter/material.dart';
import 'package:fvapp/admin/controllers/event_controller.dart';
import 'package:fvapp/admin/models/event_model.dart';
import 'package:fvapp/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class EventRentScreen extends StatelessWidget {
  final EventController _eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Event')),
      body: Obx(
        () => ListView.builder(
          itemCount: _eventController.events.length,
          itemBuilder: (context, index) {
            final event = _eventController.events[index];
            final formattedDate = DateFormat('dd MMM yyyy').format(event.date); // Format date
            return ListTile(
              title: Text(event.eventName),
              subtitle: Text('${event.description}\nTanggal: $formattedDate'), // Include date in subtitle
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _eventController.deleteEvent(event.eventId);
                  FVLoaders.successSnackBar(title: 'Berhasil!', message: 'Jadwal berhasil dihapus');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
