import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import 'patient_list_widget.dart';
import 'doctor_list_widget.dart';
import '../patient/patient_bloc/patient_bloc.dart';
import '../patient/patient_bloc/patient_event.dart';
import '../doctor/blocs/doctor_bloc.dart';
import '../doctor/blocs/doctor_event.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Patient? _selectedPatient;
  Map<String, dynamic>? _selectedDoctor;
  Appointment? _selectedAppointment;

  String? _appointmentReason; // New field for appointment reason
  List<String> _notes = []; // New field for notes

  Map<DateTime, List<Appointment>> _groupedAppointments = {};

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
    context.read<DoctorBloc>().add(FetchAllDoctors());
  }

  void _groupAppointments() {
    // Populate _groupedAppointments based on your actual data source
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _groupedAppointments[day] ?? [];
  }

  void _addNewAppointment() {
    if (_selectedPatient != null &&
        _selectedDay != null &&
        _selectedDoctor != null) {
      setState(() {
        Appointment newAppointment = Appointment(
          id: _selectedPatient!.id!,
          patientName: _selectedPatient!.firstName!,
          date: _selectedDay!,

          doctorName: _selectedDoctor!['name']!,
          appointmentReason:
              _appointmentReason ?? 'General Checkup', // New field
          notes: _notes, // New field
        );
        // Add the new appointment to your data source
        _groupAppointments(); // Re-group appointments
        _selectedPatient = null;
        _selectedDoctor = null; // Reset selected doctor
        _appointmentReason = null; // Reset appointment reason
        _notes.clear(); // Clear notes
        _selectedAppointment = null;
      });
    }
  }

  void _addNote() {
    setState(() {
      _notes.add(''); // Add an empty note for the user to fill
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Calendar'),
        backgroundColor: Color(0xFF6ABEDC),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: TableCalendar(
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
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      itemCount: _getAppointmentsForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final appointment =
                            _getAppointmentsForDay(_selectedDay!)[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          title: Text(
                            appointment.patientName,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          leading: Icon(Icons.access_time, color: Colors.teal),
                          tileColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                // Remove appointment from your data source
                                _groupAppointments();
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _selectedAppointment = appointment;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: PatientListWidget(
                        onPatientSelected: (Patient patient) {
                          setState(() {
                            _selectedPatient = patient;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: DoctorListWidget(
                        onDoctorSelected: (doctor) {
                          setState(() {
                            _selectedDoctor = doctor;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    if (_selectedPatient != null) ...[
                      Text(
                        'Patient: ${_selectedPatient!.firstName} ${_selectedPatient!.lastName},patientid:${_selectedPatient!.id!}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                    ],
                    if (_selectedDoctor != null) ...[
                      Text(
                        'Doctor: ${_selectedDoctor!['name']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                    ],
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Appointment Reason',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _appointmentReason = value;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _addNote,
                      child: Text('Add Note'),
                    ),
                    for (int i = 0; i < _notes.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          initialValue: _notes[i],
                          decoration: InputDecoration(
                            labelText: 'Note ${i + 1}',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _notes[i] = value;
                          },
                        ),
                      ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _addNewAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Add Appointment',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
