import 'package:flutter_bloc/flutter_bloc.dart';
import 'patient_event.dart';
import 'patient_state.dart';
import '../../../services/patient_api_service.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientApiService patientApiService;

  PatientBloc(this.patientApiService) : super(PatientInitial()) {
    on<LoadPatients>(_onLoadPatients);
    on<DeletePatient>(_onDeletePatient);
    on<AddPayment>(_onAddPayment); // Added event handler
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
      add(LoadPatients()); // Reload patients after deletion
    } catch (e) {
      emit(PatientError(e.toString()));
    }
  }

  Future<void> _onAddPayment(
      AddPayment event, Emitter<PatientState> emit) async {
    emit(PaymentLoading()); // Optional: Add loading state for payment

    try {
      await patientApiService.addPayment(event.patientId, event.paymentData);
      emit(PaymentSuccess()); // Emit success state
    } catch (e) {
      emit(PaymentError(e.toString())); // Emit error state
    }
  }
}
