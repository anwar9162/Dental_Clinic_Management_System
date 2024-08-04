import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_patient_event.dart';
import 'add_patient_state.dart';
import '../../../services/patient_api_service.dart';

class AddPatientBloc extends Bloc<AddPatientEvent, AddPatientState> {
  final PatientApiService patientApiService;

  AddPatientBloc(this.patientApiService) : super(AddPatientInitial()) {
    on<SubmitPatientForm>(_onSubmitPatientForm);
  }

  void _onSubmitPatientForm(
      SubmitPatientForm event, Emitter<AddPatientState> emit) async {
    try {
      emit(AddPatientLoading());
      await patientApiService.createPatient(event.patientData);
      emit(AddPatientSuccess());
    } catch (e) {
      emit(AddPatientFailure(
          error: e.toString())); // Pass the error message to the state
    }
  }
}
