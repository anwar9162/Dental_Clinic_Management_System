import 'package:flutter_bloc/flutter_bloc.dart';
import 'patient_event.dart';
import 'patient_state.dart';
import '../../../services/patient_api_service.dart'; // Ensure this path is correct

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientApiService patientApiService;

  PatientBloc(this.patientApiService) : super(PatientInitial()) {
    on<LoadPatients>(_onLoadPatients);
    on<DeletePatient>(_onDeletePatient);
  }

  Future<void> _onLoadPatients(
      LoadPatients event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final patients = await patientApiService.getAllPatients();
      emit(PatientLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onDeletePatient(
      DeletePatient event, Emitter<PatientState> emit) async {
    try {
      await patientApiService.deletePatient(event.id);
      // Optionally reload patients after deletion
      add(LoadPatients());
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }
}
