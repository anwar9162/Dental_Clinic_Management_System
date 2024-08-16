/*

import 'package:flutter/material.dart';
import '../models/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'John Doe',
      date: DateTime.now(),
      doctorName: 'Dr. Smith',
      firstVisitDate: DateTime.now().subtract(Duration(days: 365)),
      lastTreatment: 'Teeth Cleaning',
      currentAppointmentReason: 'Follow-up',
    ),
    Appointment(
      id: '2',
      patientName: 'Jane Doe',
      date: DateTime.now().add(Duration(days: 1)),
      doctorName: 'Dr. Brown',
      firstVisitDate: DateTime.now().subtract(Duration(days: 200)),
      lastTreatment: 'Cavity Inspection',
      currentAppointmentReason: 'Toothache',
    ),
    // Add more mock appointments as needed
  ];

  List<Appointment> get appointments => _appointments;

  Appointment? _selectedAppointment;
  Appointment? get selectedAppointment => _selectedAppointment;

  void selectAppointment(Appointment appointment) {
    _selectedAppointment = appointment;
    notifyListeners();
  }

  void deleteAppointment(String id) {
    _appointments.removeWhere((appointment) => appointment.id == id);
    notifyListeners();
  }
}
*/