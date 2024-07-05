import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Name: ${appointment.patientName}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Date: ${appointment.date.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Description: ${appointment.description}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Doctor Name: ${appointment.doctorName}',
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
