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
import 'blocs/appointment_bloc.dart';
import 'blocs/appointment_event.dart';
import 'blocs/appointment_state.dart';
import 'confirm_appointment_screen.dart';
import 'package:logger/logger.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  final Logger _logger = Logger(); // Logger instance

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Patient? _selectedPatient;
  Map<String, dynamic>? _selectedDoctor;
  Appointment? _selectedAppointment;

  String? _appointmentReason;
  List<Note> _notes = [];

  Map<DateTime, List<Appointment>> _groupedAppointments = {};

  @override
  void initState() {
    super.initState();
    // Load patients and doctors on initialization
    context.read<PatientBloc>().add(LoadPatients());
    context.read<DoctorBloc>().add(FetchAllDoctors());

    // Fetch all appointments
    context.read<AppointmentBloc>().add(FetchAllAppointments());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AppointmentBloc>().stream.listen((state) {
      if (state is AppointmentLoaded) {
        _logger
            .i('Appointments loaded with ${state.appointments.length} items');
        _groupAppointments(state.appointments);
      } else if (state is AppointmentError) {
        _logger.e('Error loading appointments: ${state.message}');
      }
    });
  }

  void _groupAppointments(List<Appointment> appointments) {
    final grouped = <DateTime, List<Appointment>>{};
    for (var appointment in appointments) {
      final date = DateTime(
          appointment.date.year, appointment.date.month, appointment.date.day);
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(appointment);
    }
    setState(() {
      _groupedAppointments = grouped;
      _logger.i(
          'Appointments grouped by date: ${_groupedAppointments.keys.length} unique dates');
    });
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _groupedAppointments[date] ?? [];
  }

  void _addNewAppointment() {
    if (_selectedPatient != null &&
        _selectedDay != null &&
        _selectedDoctor != null) {
      showConfirmAppointmentDialog(
        context: context,
        selectedPatient: _selectedPatient!,
        selectedDoctor: _selectedDoctor!,
        selectedDate: _selectedDay!,
        appointmentReason: _appointmentReason ?? 'General Checkup',
        notes: _notes.map((note) => note.content).toList(),
        onConfirm: () {
          Appointment newAppointment = Appointment(
            id: _selectedPatient!.id!,
            date: _selectedDay!,
            doctorid: _selectedDoctor!['_id'],
            patientName:
                '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}',
            appointmentReason: _appointmentReason ?? 'General Checkup',
            notes: _notes,
            patient: _selectedPatient!.id,
            doctor: _selectedDoctor!['_id'],
          );

          context
              .read<AppointmentBloc>()
              .add(CreateAppointment(newAppointment));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Appointment confirmed!')),
          );
          _logger.i('New appointment created: ${newAppointment.id}');
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a patient, doctor, and date.')),
      );
      _logger.w(
          'Failed to add new appointment: Missing patient, doctor, or date.');
    }
  }

  void _addNote() {
    setState(() {
      _notes.add(Note(content: ''));
      _logger.i('New note added.');
    });
  }

  void _removeNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _logger.i('Note removed at index: $index');
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
                  child: SingleChildScrollView(
                    child: TableCalendar(
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
                        _logger.i(
                            'Day selected: ${selectedDay.toLocal().toString().split(' ')[0]}');
                        // Optionally log the number of appointments for the selected day
                        _logger.i(
                            'Appointments for ${selectedDay.toLocal().toString().split(' ')[0]}: ${_getAppointmentsForDay(selectedDay).length}');
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
                      itemCount: _getAppointmentsForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final appointment =
                            _getAppointmentsForDay(_selectedDay!)[index];
                        final patientDetails = appointment.patientDetails;
                        final doctorDetails = appointment.doctorDetails;

                        // Build patient and doctor details text
                        final patientText = patientDetails != null
                            ? '${patientDetails.firstName} ${patientDetails.lastName} (Phone: ${patientDetails.phoneNumber})'
                            : 'No Patient Info';

                        final doctorText = doctorDetails != null
                            ? 'Doctor: ${doctorDetails.name} (Phone: ${doctorDetails.contactInfo.phone})'
                            : 'No Doctor Info';

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          title: Text(
                            patientText,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          subtitle: Text(
                            '$doctorText\nReason: ${appointment.appointmentReason ?? 'No Reason'}',
                          ),
                          leading: Icon(Icons.access_time, color: Colors.teal),
                          tileColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Add logic to handle appointment deletion
                              setState(() {
                                // Example: Removing an appointment from the grouped map
                                _groupedAppointments[_selectedDay]
                                    ?.removeAt(index);
                                if (_groupedAppointments[_selectedDay]
                                        ?.isEmpty ??
                                    false) {
                                  _groupedAppointments.remove(_selectedDay);
                                }
                              });
                              _logger
                                  .i('Appointment deleted: ${appointment.id}');
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _selectedAppointment = appointment;
                            });
                            _logger
                                .i('Appointment selected: ${appointment.id}');
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient selection
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: PatientListWidget(
                          onPatientSelected: (Patient patient) {
                            setState(() {
                              _selectedPatient = patient;
                            });
                            _logger.i(
                                'Patient selected: ${patient.firstName} ${patient.lastName}');
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Doctor selection
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: DoctorListWidget(
                          onDoctorSelected: (doctor) {
                            setState(() {
                              _selectedDoctor = doctor;
                            });
                            _logger.i('Doctor selected: ${doctor['name']}');
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Display selected patient info
                      if (_selectedPatient != null) ...[
                        Text(
                          'Patient: ${_selectedPatient!.firstName} ${_selectedPatient!.lastName}, Patient ID: ${_selectedPatient!.id!}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                      ],
                      // Display selected doctor info
                      if (_selectedDoctor != null) ...[
                        Text(
                          'Doctor: ${_selectedDoctor!['name']}, Doctor ID: ${_selectedDoctor!['_id']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                      ],
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Appointment Reason',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _appointmentReason = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notes:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ..._notes.asMap().entries.map((entry) {
                            int index = entry.key;
                            Note note = entry.value;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Note ${index + 1}',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _notes[index] = Note(content: value);
                                        });
                                        _logger
                                            .i('Note updated at index: $index');
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeNote(index),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          ElevatedButton.icon(
                            icon: Icon(Icons.add, color: Colors.white),
                            label: Text('Add Note'),
                            onPressed: _addNote,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: _addNewAppointment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6ABEDC),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Center(
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
          ),
        ],
      ),
    );
  }
}
