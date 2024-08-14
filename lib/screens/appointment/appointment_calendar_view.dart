import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import 'patient_list_widget.dart';
import 'doctor_list_widget.dart';

class AppointmentCalendarView extends StatefulWidget {
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
  final Function(String) onDeleteAppointment;

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
    required this.onDeleteAppointment,
  }) : super(key: key);

  @override
  _AppointmentCalendarViewState createState() =>
      _AppointmentCalendarViewState();
}

class _AppointmentCalendarViewState extends State<AppointmentCalendarView> {
  late TextEditingController _appointmentReasonController;

  @override
  void initState() {
    super.initState();
    _appointmentReasonController = TextEditingController(
      text: widget.appointmentReason ?? '',
    );
  }

  @override
  void dispose() {
    _appointmentReasonController.dispose();
    super.dispose();
  }

  void _clearAppointmentReason() {
    setState(() {
      _appointmentReasonController.clear(); // Clear the controller's text
      widget
          .onAppointmentReasonChanged(''); // Update the state via the callback
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
                      focusedDay: widget.focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(widget.selectedDay, day),
                      onDaySelected: widget.onDaySelected,
                      eventLoader: widget.getAppointmentsForDay,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: const Color.fromARGB(255, 162, 224, 218),
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
                          final normalizedDate = _normalizeDate(date);
                          final appointmentCount = widget
                                  .groupedAppointments[normalizedDate]
                                  ?.length ??
                              0;

                          if (appointmentCount > 0) {
                            return Positioned(
                              right: 22.0,
                              bottom: 15.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 230, 38),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text(
                                    appointmentCount.toString(),
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 20, 17, 17),
                                      fontSize: 16.0,
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
                if (widget.selectedDay != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.getAppointmentsForDay(widget.selectedDay!).length} Appointment(s) on ${widget.selectedDay!.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: widget
                          .getAppointmentsForDay(widget.selectedDay!)
                          .length,
                      itemBuilder: (context, index) {
                        final appointment = widget
                            .getAppointmentsForDay(widget.selectedDay!)[index];
                        final patientDetails = appointment.patientDetails;
                        final doctorDetails = appointment.doctorDetails;

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
                              widget.onDeleteAppointment(appointment.id!);
                            },
                          ),
                          onTap: () => widget.onAppointmentTap(appointment),
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
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: PatientListWidget(
                          onPatientSelected: widget.onPatientSelected,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: DoctorListWidget(
                          onDoctorSelected: widget.onDoctorSelected,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      if (widget.selectedPatient != null) ...[
                        Text(
                          'Patient: ${widget.selectedPatient!.firstName} ${widget.selectedPatient!.lastName}',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 8.0),
                      ],
                      if (widget.selectedDoctor != null) ...[
                        Text(
                          'Doctor: ${widget.selectedDoctor!['name']}',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 8.0),
                      ],
                      TextField(
                        controller: _appointmentReasonController,
                        decoration: InputDecoration(
                          labelText: 'Appointment Reason',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: widget.onAppointmentReasonChanged,
                      ),
                      SizedBox(height: 16.0),
                      Column(
                        children: [
                          ...widget.notes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final note = entry.value;
                            return ListTile(
                              title: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Note ${index + 1}'),
                                onChanged: (value) {
                                  // Update note content
                                  widget.notes[index] = Note(content: value);
                                },
                                controller:
                                    TextEditingController(text: note.content),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => widget.onRemoveNote(index),
                              ),
                            );
                          }).toList(),
                          ElevatedButton(
                            onPressed: () => widget.onAddNote(),
                            child: Text('Add Note'),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () => widget.onAddNewAppointment(),
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

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
