import 'package:equatable/equatable.dart';
// doctor_state.dart

abstract class DoctorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorListLoading extends DoctorState {}

class DoctorDetailLoading extends DoctorState {}

class DoctorsLoaded extends DoctorState {
  final List<Map<String, dynamic>> doctors;

  DoctorsLoaded(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

class DoctorDetailLoaded extends DoctorState {
  final Map<String, dynamic> doctor;

  DoctorDetailLoaded(this.doctor);

  @override
  List<Object?> get props => [doctor];
}

class DoctorError extends DoctorState {
  final String message;

  DoctorError(this.message);

  @override
  List<Object?> get props => [message];
}

class DoctorAdded extends DoctorState {}

class DoctorDeleteSuccess extends DoctorState {} // New state for delete success


