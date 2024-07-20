import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'John Doe',
      date: DateTime(2024, 7, 15, 9, 0),
      description: 'Routine cleaning',
      doctorName: 'Dr. Smith',
    ),
    Appointment(
      id: '2',
      patientName: 'Jane Doe',
      date: DateTime(2024, 7, 15, 11, 0),
      description: 'Root Canal treatment',
      doctorName: 'Dr. Smith',
    ),
    Appointment(
      id: '3',
      patientName: 'Alice Smith',
      date: DateTime(2024, 7, 15, 14, 0),
      description: 'Checkup',
      doctorName: 'Dr. Brown',
    ),
    Appointment(
      id: '4',
      patientName: 'Bob Johnson',
      date: DateTime(2024, 7, 15, 16, 0),
      description: 'Consultation for braces',
      doctorName: 'Dr. Smith',
    ),
  ];
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
  Appointment? _selectedAppointment;
  String _messageContent = '';

  Map<DateTime, List<Appointment>> _groupedAppointments = {};

  @override
  void initState() {
    super.initState();
    _groupAppointments();
  }

  void _groupAppointments() {
    _groupedAppointments = {};
    for (var appointment in _appointments) {
      DateTime date = DateTime.utc(
          appointment.date.year, appointment.date.month, appointment.date.day);
      if (_groupedAppointments[date] == null) {
        _groupedAppointments[date] = [];
      }
      _groupedAppointments[date]!.add(appointment);
    }
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _groupedAppointments[day] ?? [];
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
        _selectedAppointment = null;
      });
    }
  }

  void _sendSMS(String message) {
    // Implement SMS sending logic here
    print('Sending SMS to ${_selectedAppointment!.patientName}: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Calendar'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      eventLoader: _getAppointmentsForDay,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                        markerDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.teal),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.teal),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          final appointmentCount =
                              _groupedAppointments[date]?.length ?? 0;
                          if (appointmentCount > 0) {
                            return Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text(
                                    appointmentCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    if (_selectedDay != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${_getAppointmentsForDay(_selectedDay!).length} Appointment(s) on ${_selectedDay!.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(8.0),
                          children: _getAppointmentsForDay(_selectedDay!)
                              .map((appointment) {
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              title: Text(
                                appointment.patientName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(appointment.description),
                              leading:
                                  Icon(Icons.access_time, color: Colors.teal),
                              tileColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _appointments.remove(appointment);
                                        _groupAppointments();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.sms, color: Colors.blue),
                                    onPressed: () {
                                      print(
                                          'Send SMS to ${appointment.patientName}');
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedAppointment = appointment;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: DropdownSearch<Patient>(
                      items: _patients,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select Patient",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: "Search Patient",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      onChanged: (Patient? newValue) {
                        setState(() {
                          _selectedPatient = newValue;
                        });
                      },
                      itemAsString: (Patient patient) => patient.name,
                      selectedItem: _selectedPatient,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addNewAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                    child: Text('Add Appointment'),
                  ),
                  SizedBox(height: 16.0),
                  if (_selectedAppointment != null)
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Details',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text('Name: ${_selectedAppointment!.patientName}'),
                          Text(
                              'Date: ${_selectedAppointment!.date.toLocal().toString().split(' ')[0]}'),
                          Text(
                              'Description: ${_selectedAppointment!.description}'),
                          Text('Doctor: ${_selectedAppointment!.doctorName}'),
                        ],
                      ),
                    ),
                  SizedBox(height: 16.0),
                  if (_selectedAppointment != null)
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Message:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _messageContent = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Type your message here',
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              _sendSMS(_messageContent);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text('Send'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
