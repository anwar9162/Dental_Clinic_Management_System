import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import 'patient_list_widget.dart';
import 'doctor_list_widget.dart';

class AppointmentCalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<Appointment>> groupedAppointments;
  final Function(DateTime, DateTime) onDaySelected;
  final List<Appointment> Function(DateTime) getAppointmentsForDay;
  final Patient? selectedPatient;
  final Map<String, dynamic>? selectedDoctor;
  final Function(Patient) onPatientSelected;
  final Function(Map<String, dynamic>) onDoctorSelected;
  final String? appointmentReason;
  final Function(String) onAppointmentReasonChanged;
  final List<Note> notes;
  final Function onAddNote;
  final Function(int) onRemoveNote;
  final Function onAddNewAppointment;
  final Function(Appointment) onAppointmentTap;

  const AppointmentCalendarView({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.groupedAppointments,
    required this.onDaySelected,
    required this.getAppointmentsForDay,
    required this.selectedPatient,
    required this.selectedDoctor,
    required this.onPatientSelected,
    required this.onDoctorSelected,
    required this.appointmentReason,
    required this.onAppointmentReasonChanged,
    required this.notes,
    required this.onAddNote,
    required this.onRemoveNote,
    required this.onAddNewAppointment,
    required this.onAppointmentTap,
  }) : super(key: key);

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
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDay, day),
                      onDaySelected: onDaySelected,
                      eventLoader: getAppointmentsForDay,
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
                              groupedAppointments[date]?.length ?? 0;
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
                if (selectedDay != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${getAppointmentsForDay(selectedDay!).length} Appointment(s) on ${selectedDay!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: getAppointmentsForDay(selectedDay!).length,
                      itemBuilder: (context, index) {
                        final appointment =
                            getAppointmentsForDay(selectedDay!)[index];
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
                              // Logic for deletion can be added here
                            },
                          ),
                          onTap: () => onAppointmentTap(appointment),
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
                          onPatientSelected: onPatientSelected,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Doctor selection
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: DoctorListWidget(
                          onDoctorSelected: onDoctorSelected,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Display selected patient info
                      if (selectedPatient != null) ...[
                        Text(
                          'Patient: ${selectedPatient!.firstName} ${selectedPatient!.lastName}, Patient ID: ${selectedPatient!.id!}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                      ],
                      // Display selected doctor info
                      if (selectedDoctor != null) ...[
                        Text(
                          'Doctor: ${selectedDoctor!['name']}, Doctor ID: ${selectedDoctor!['_id']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                      ],
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Appointment Reason',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: onAppointmentReasonChanged,
                        controller:
                            TextEditingController(text: appointmentReason),
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        children: [
                          ...notes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final note = entry.value;
                            return ListTile(
                              title: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Note ${index + 1}'),
                                onChanged: (value) {
                                  // Update note content
                                  notes[index] = Note(content: value);
                                },
                                controller:
                                    TextEditingController(text: note.content),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => onRemoveNote(index),
                              ),
                            );
                          }).toList(),
                          ElevatedButton(
                            onPressed: () => onAddNote(),
                            child: Text('Add Note'),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () => onAddNewAppointment(),
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
