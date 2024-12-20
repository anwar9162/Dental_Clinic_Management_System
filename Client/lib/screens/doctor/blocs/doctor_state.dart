import 'package:equatable/equatable.dart';

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

class DoctorUpdated extends DoctorState {
  final String message;

  DoctorUpdated([this.message = 'Doctor updated successfully']);

  @override
  List<Object?> get props => [message];
}

class DoctorError extends DoctorState {
  final String message;

  DoctorError(this.message);

  @override
  List<Object?> get props => [message];
}

class DoctorAdded extends DoctorState {
  final String message; // Optional, for success message

  DoctorAdded([this.message = 'Doctor added successfully']);

  @override
  List<Object?> get props => [message];
}

class DoctorDeleteSuccess extends DoctorState {
  final String message; // Optional, for success message

  DoctorDeleteSuccess([this.message = 'Doctor deleted successfully']);

  @override
  List<Object?> get props => [message];
}
