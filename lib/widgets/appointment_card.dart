import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;

  AppointmentCard({required this.appointment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(appointment.patientName),
        subtitle:
            Text('${appointment.patientName} with ${appointment.doctorName}'),
        trailing: Text('${appointment.date.toLocal()}'.split(' ')[0]),
      ),
    );
  }
}
