// patient_event.dart
import 'package:equatable/equatable.dart';

abstract class PatientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPatients extends PatientEvent {}

class DeletePatient extends PatientEvent {
  final String id;

  DeletePatient(this.id);

  @override
  List<Object> get props => [id];
}
