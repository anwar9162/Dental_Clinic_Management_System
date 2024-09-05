// states/medical_information_state.dart
import 'package:equatable/equatable.dart';
import '../../../models/patient_model.dart';
import '../../../models/basic_patient_info_model.dart';

abstract class MedicalInformationState extends Equatable {
  @override
  List<Object> get props => [];
}

class MedicalInformationInitial extends MedicalInformationState {}

class MedicalInformationLoading extends MedicalInformationState {}

class MedicalInformationLoaded extends MedicalInformationState {
  final List<Patient> patients;

  MedicalInformationLoaded(this.patients);

  @override
  List<Object> get props => [patients];
}

class MedicalInformationBasicInfoLoaded extends MedicalInformationState {
  final List<PatientBasicInfo> basicPatientInfo;

  MedicalInformationBasicInfoLoaded(this.basicPatientInfo);

  @override
  List<Object> get props => [basicPatientInfo];
}

class MedicalInformationError extends MedicalInformationState {
  final String message;

  MedicalInformationError(this.message);

  @override
  List<Object> get props => [message];
}
