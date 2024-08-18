import 'package:flutter_bloc/flutter_bloc.dart';
import 'patient_event.dart';
import 'patient_state.dart';
import '../../../services/patient_api_service.dart';
import '../../../models/patient_model.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientApiService patientApiService;

  PatientBloc(this.patientApiService) : super(PatientInitial()) {
    on<LoadPatients>(_onLoadPatients);
    on<LoadTodaysPatients>(_onLoadTodaysPatients);

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

  Future<void> _onLoadTodaysPatients(
      LoadTodaysPatients event, Emitter<PatientState> emit) async {
    emit(PatientLoading());
    try {
      final todaysPatientsJson = await patientApiService.getTodaysPatient();
      print('Raw JSON data of today\'s patients: $todaysPatientsJson');

      // Convert raw JSON data to List<Patient>
      final todaysPatients = (todaysPatientsJson as List<dynamic>)
          .map((json) => Patient.fromJson(json as Map<String, dynamic>))
          .toList();
      print('Converted Patient objects: $todaysPatients');

      emit(TodaysPatientsLoaded(todaysPatients));
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onDeletePatient(
      DeletePatient event, Emitter<PatientState> emit) async {
    try {
      await patientApiService.deletePatient(event.id);
      add(LoadPatients()); // Reload patients after deletion
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }
}
