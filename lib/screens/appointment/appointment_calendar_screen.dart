import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart'; // Import patient model
import 'add_appointment_screen.dart';
import 'appointment_detail_screen.dart';
import '../../widgets/navigation_drawer.dart' as custom;
import '../../widgets/appointment_card.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'John Doe',
      date: DateTime.now(),
      description: 'Routine check-up',
      doctorName: 'Dr. Smith',
    ),
    Appointment(
      id: '2',
      patientName: 'Jane Doe',
      date: DateTime.now().add(Duration(days: 1)),
      description: 'Teeth cleaning',
      doctorName: 'Dr. Brown',
    ),
  ];

  List<Patient> _patients = [
    Patient(id: '1', name: 'John Doe'),
    Patient(id: '2', name: 'Jane Doe'),
  ];

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _appointments
        .where((appointment) => isSameDay(appointment.date, day))
        .toList();
  }

  void _addNewAppointment(Appointment newAppointment) {
    setState(() {
      _appointments.add(newAppointment);
    });
  }

  void _removeAppointment(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment);
    });
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
            flex: 2,
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _selectedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, _) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                    todayBuilder: (context, date, _) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: DragTarget<Appointment>(
                    onAccept: (appointment) {
                      _removeAppointment(appointment);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _getAppointmentsForDay(_selectedDay).length,
                        itemBuilder: (context, index) {
                          final appointment =
                              _getAppointmentsForDay(_selectedDay)[index];
                          return Draggable<Appointment>(
                            data: appointment,
                            child: AppointmentCard(
                              appointment: appointment,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AppointmentDetailScreen(
                                            appointment: appointment),
                                  ),
                                );
                              },
                            ),
                            feedback: Material(
                              child: AppointmentCard(
                                appointment: appointment,
                                onTap: () {},
                              ),
                            ),
                            childWhenDragging: Container(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                TextField(
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
                Expanded(
                  child: ListView.builder(
                    itemCount: _patients.length,
                    itemBuilder: (context, index) {
                      final patient = _patients[index];
                      return Draggable<Patient>(
                        data: patient,
                        child: ListTile(
                          title: Text(patient.name),
                        ),
                        feedback: Material(
                          child: ListTile(
                            title: Text(patient.name),
                          ),
                        ),
                        childWhenDragging: Container(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAppointment = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAppointmentScreen()),
          );

          if (newAppointment != null) {
            _addNewAppointment(newAppointment);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Add Appointment on ${selectedDate.toLocal()}'.split(' ')[0]),
          content: AddAppointmentScreen(),
        );
      },
    );
  }
}
