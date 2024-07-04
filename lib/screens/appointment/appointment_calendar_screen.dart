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
    Patient(id: '1', name: 'John Doe'),
    Patient(id: '2', name: 'Jane Doe'),
    Patient(id: '3', name: 'Alice Smith'),
    Patient(id: '4', name: 'Bob Johnson'),
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

  void _removeAppointment(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment);
      _groupAppointments();
    });
  }

  Color _getAppointmentColor(int index) {
    List<Color> colors = [
      Colors.teal,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.green,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Calendar'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TableCalendar<Appointment>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    eventLoader: _getAppointmentsForDay,
                    calendarBuilders: CalendarBuilders<Appointment>(
                      markerBuilder: (context, date, events) {
                        if (events.isEmpty) return SizedBox();
                        return Column(
                          children: events.asMap().entries.map((entry) {
                            int idx = entry.key;
                            Appointment appointment = entry.value;
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 1.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: _getAppointmentColor(idx),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                '${idx + 1}. ${appointment.patientName}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 3,
                      markerDecoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      markerSizeScale: 0.4,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _getAppointmentsForDay(_selectedDay ?? _focusedDay)
                            .length,
                    itemBuilder: (context, index) {
                      final appointment = _getAppointmentsForDay(
                          _selectedDay ?? _focusedDay)[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(appointment.patientName),
                          subtitle: Text(appointment.description),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeAppointment(appointment),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_selectedPatient != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _addNewAppointment,
                      child: Text('Add Appointment'),
                    ),
                  ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Patients',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _patients = _patients
                            .where((patient) => patient.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _patients.length,
                    itemBuilder: (context, index) {
                      final patient = _patients[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(patient.name),
                          onTap: () {
                            setState(() {
                              _selectedPatient = patient;
                            });
                          },
                          selected: _selectedPatient == patient,
                          selectedTileColor: Colors.blue[100],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
