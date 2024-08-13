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
import 'appointment_calendar_view.dart';

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
      } else if (state is AppointmentSuccess) {
        _logger.i('Appointment successfully created: ${state.appointment.id}');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Clear all fields
        setState(() {
          _selectedPatient = null;
          _selectedDoctor = null;

          _appointmentReason = null;
          _notes.clear();
        });

        // Fetch all appointments to update the UI
        context.read<AppointmentBloc>().add(FetchAllAppointments());
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
            date: _selectedDay!,
            doctorid: _selectedDoctor!['_id'],
            patientName:
                '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}',
            appointmentReason: _appointmentReason ?? 'General Checkup',
            notes: _notes,
            patient: _selectedPatient!.id,
            doctor: _selectedDoctor!['_id'],
          );

          // Dispatch the CreateAppointment event
          context
              .read<AppointmentBloc>()
              .add(CreateAppointment(newAppointment));
          // Fetch all appointments to update the UI
          context.read<AppointmentBloc>().add(FetchAllAppointments());
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
    return AppointmentCalendarView(
      focusedDay: _focusedDay,
      selectedDay: _selectedDay,
      groupedAppointments: _groupedAppointments,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _logger.i('Day selected: ${selectedDay.toLocal()}');
      },
      getAppointmentsForDay: _getAppointmentsForDay,
      selectedPatient: _selectedPatient,
      selectedDoctor: _selectedDoctor,
      onPatientSelected: (Patient patient) {
        setState(() {
          _selectedPatient = patient;
        });
        _logger.i('Patient selected: ${patient.firstName} ${patient.lastName}');
      },
      onDoctorSelected: (doctor) {
        setState(() {
          _selectedDoctor = doctor;
        });
        _logger.i('Doctor selected: ${doctor['name']}');
      },
      appointmentReason: _appointmentReason,
      onAppointmentReasonChanged: (value) {
        setState(() {
          _appointmentReason = value;
        });
      },
      notes: _notes,
      onAddNote: _addNote,
      onRemoveNote: _removeNote,
      onAddNewAppointment: _addNewAppointment,
      onAppointmentTap: (appointment) {
        setState(() {
          _selectedAppointment = appointment;
        });
        _logger.i('Appointment selected: ${appointment.id}');
      },
    );
  }
}
