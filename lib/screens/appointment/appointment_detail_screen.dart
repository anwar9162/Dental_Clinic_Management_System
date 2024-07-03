import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  AppointmentDetailScreen({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${appointment.patientName}',
                style: TextStyle(fontSize: 18)),
            Text('Doctor: ${appointment.doctorName}',
                style: TextStyle(fontSize: 18)),
            Text('Date: ${appointment.date.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 18)),
            Text('Time: ${appointment.time}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Description:', style: TextStyle(fontSize: 18)),
            Text(appointment.description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
