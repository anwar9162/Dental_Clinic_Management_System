import 'package:equatable/equatable.dart';
import '../../../models/appointment_model.dart';

abstract class AppointmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentSuccess extends AppointmentState {
  final Appointment appointment;

  AppointmentSuccess(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
