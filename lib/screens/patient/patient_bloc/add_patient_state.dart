abstract class AddPatientState {}

class AddPatientInitial extends AddPatientState {}

class AddPatientLoading extends AddPatientState {}

class AddPatientSuccess extends AddPatientState {}

class AddPatientFailure extends AddPatientState {
  final String error;

  AddPatientFailure({required this.error});
}
