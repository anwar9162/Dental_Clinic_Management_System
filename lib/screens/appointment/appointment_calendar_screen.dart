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

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Patient? _selectedPatient;
  Map<String, dynamic>?
      _selectedDoctor; // Changed doctorId to a map for flexibility
  Appointment? _selectedAppointment;

  String? _appointmentReason;
  List<Note> _notes = []; // Changed this to List<Note>

  Map<DateTime, List<Appointment>> _groupedAppointments = {};

  @override
  void initState() {
    super.initState();
    // Load patients and doctors on initialization
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
      showConfirmAppointmentDialog(
        context: context,
        selectedPatient: _selectedPatient!,
        selectedDoctor: _selectedDoctor!,
        selectedDate: _selectedDay!,
        appointmentReason: _appointmentReason ?? 'General Checkup',
        notes: _notes
            .map((note) => note.content)
            .toList(), // Convert List<Note> to List<String>
        onConfirm: () {
          // Create a new appointment with List<Note>
          Appointment newAppointment = Appointment(
            id: _selectedPatient!.id!, // Use patient's ID
            date: _selectedDay!,
            doctorid: _selectedDoctor!['_id'], // Use doctor's ID
            patientName:
                '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}', // Get the patient name
            appointmentReason: _appointmentReason ?? 'General Checkup',
            notes: _notes, // Pass List<Note> directly
            patient: _selectedPatient!
                .id, // Assuming patient is required in your API
            doctor: _selectedDoctor![
                '_id'], // Assuming doctor is required in your API
          );

          // Dispatch CreateAppointment event to the AppointmentBloc
          context
              .read<AppointmentBloc>()
              .add(CreateAppointment(newAppointment));

          // Optionally show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Appointment confirmed!')),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a patient, doctor, and date.')),
      );
    }
  }

  void _resetSelection() {
    setState(() {
      _selectedPatient = null;
      _selectedDoctor = null;
      _appointmentReason = null;
      _notes.clear(); // Clear the notes list
      _selectedAppointment = null;
    });
  }

  void _addNote() {
    setState(() {
      _notes.add(Note(content: '')); // Initialize with an empty note
    });
  }

  void _removeNote(int index) {
    setState(() {
      _notes.removeAt(index); // Remove the specified note
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
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          title: Text(
                            appointment.patientName!,
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
                                // After deleting, regroup appointments
                                _groupAppointments();
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _selectedAppointment =
                                  appointment; // Set selected appointment
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
                                          _notes[index] = Note(
                                              content:
                                                  value); // Update the note
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _removeNote(index), // Remove the note
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
