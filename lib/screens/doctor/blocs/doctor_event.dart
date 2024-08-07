import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllDoctors extends DoctorEvent {}

class FetchDoctorById extends DoctorEvent {
  final String id;

  FetchDoctorById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddDoctor extends DoctorEvent {
  final Map<String, dynamic> doctorData;

  AddDoctor(this.doctorData);

  @override
  List<Object?> get props => [doctorData];
}

class DeleteDoctor extends DoctorEvent {
  final String id;

  DeleteDoctor(this.id);

  @override
  List<Object?> get props => [id];
}
