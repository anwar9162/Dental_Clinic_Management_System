import 'package:equatable/equatable.dart';
import '../../../models/appointment_model.dart';

abstract class AppointmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllAppointments extends AppointmentEvent {}

class FetchAppointmentById extends AppointmentEvent {
  final String id;

  FetchAppointmentById(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateAppointment extends AppointmentEvent {
  final Appointment appointment;

  CreateAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class DeleteAppointment extends AppointmentEvent {
  final String id;

  DeleteAppointment(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchTodaysAppointments extends AppointmentEvent {}

class FetchVisitHistory extends AppointmentEvent {
  final String patientId;

  FetchVisitHistory(this.patientId);

  @override
  List<Object?> get props => [patientId];
}
