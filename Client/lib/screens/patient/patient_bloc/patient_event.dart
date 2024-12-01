import 'package:equatable/equatable.dart';

abstract class PatientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPatients extends PatientEvent {}

class LoadTodaysPatients extends PatientEvent {}

class DeletePatient extends PatientEvent {
  final String id;

  DeletePatient(this.id);

  @override
  List<Object> get props => [id];
}

class AddPayment extends PatientEvent {
  final String patientId;
  final Map<String, dynamic> paymentData;

  AddPayment({required this.patientId, required this.paymentData});

  @override
  List<Object> get props => [patientId, paymentData];
}
