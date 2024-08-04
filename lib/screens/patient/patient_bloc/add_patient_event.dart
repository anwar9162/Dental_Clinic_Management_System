abstract class AddPatientEvent {}

class SubmitPatientForm extends AddPatientEvent {
  final Map<String, dynamic> patientData;

  SubmitPatientForm(this.patientData);
}
