import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Appointment> _appointments = [];
  List<Patient> _patients = [
    Patient(
      id: '1',
      name: 'John Doe',
      firstVisitDate: DateTime(2023, 9, 11),
      lastTreatment: 'Cleaning',
      currentAppointmentReason: 'Brace',
    ),
    Patient(
      id: '2',
      name: 'Jane Doe',
      firstVisitDate: DateTime(2022, 5, 20),
      lastTreatment: 'Root Canal',
      currentAppointmentReason: 'Checkup',
    ),
    Patient(
      id: '3',
      name: 'Alice Smith',
      firstVisitDate: DateTime(2021, 8, 15),
      lastTreatment: 'Fillings',
      currentAppointmentReason: 'Pain in tooth',
    ),
    Patient(
      id: '4',
      name: 'Bob Johnson',
      firstVisitDate: DateTime(2020, 11, 30),
      lastTreatment: 'Extraction',
      currentAppointmentReason: 'Consultation for braces',
    ),
  ];
  Patient? _selectedPatient;

  Map<DateTime, List<Appointment>> _groupedAppointments = {};

  @override
  void initState() {
    super.initState();
    _groupAppointments();
  }

  void _groupAppointments() {
    _groupedAppointments = {};
    for (var appointment in _appointments) {
      DateTime date = DateTime.utc(appointment.date.year,
          appointment.date.month, appointment.date.day, 12);
      if (_groupedAppointments[date] == null) _groupedAppointments[date] = [];
      _groupedAppointments[date]!.add(appointment);
    }
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _groupedAppointments[
            DateTime.utc(day.year, day.month, day.day, 12)] ??
        [];
  }

  void _addNewAppointment() {
    if (_selectedPatient != null && _selectedDay != null) {
      setState(() {
        Appointment newAppointment = Appointment(
          id: DateTime.now().toString(),
          patientName: _selectedPatient!.name,
          date: _selectedDay!,
          description: 'New Appointment',
          doctorName: 'Dr. Smith',
        );
        _appointments.add(newAppointment);
        _groupAppointments();
        _selectedPatient = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Calendar'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getAppointmentsForDay,
          ),
          if (_selectedDay != null)
            Expanded(
              child: ListView(
                children:
                    _getAppointmentsForDay(_selectedDay!).map((appointment) {
                  return ListTile(
                    title: Text(appointment.patientName),
                    subtitle: Text(appointment.description),
                  );
                }).toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<Patient>(
              value: _selectedPatient,
              onChanged: (Patient? newValue) {
                setState(() {
                  _selectedPatient = newValue;
                });
              },
              items: _patients.map((Patient patient) {
                return DropdownMenuItem<Patient>(
                  value: patient,
                  child: Text(patient.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Patient',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addNewAppointment,
            child: Text('Add Appointment'),
          ),
        ],
      ),
    );
  }
}
