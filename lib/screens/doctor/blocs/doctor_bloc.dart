import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';
import '../../../services/doctor_api_service.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorApiService apiService;

  DoctorBloc(this.apiService) : super(DoctorInitial()) {
    on<FetchAllDoctors>(_onFetchAllDoctors);
    on<FetchDoctorById>(_onFetchDoctorById);
    on<AddDoctor>(_onAddDoctor);
    on<DeleteDoctor>(_onDeleteDoctor);
  }

  Future<void> _onFetchAllDoctors(
      FetchAllDoctors event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final doctors = await apiService.getAllDoctors();
      emit(DoctorsLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onFetchDoctorById(
      FetchDoctorById event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      final doctor = await apiService.getDoctorById(event.id);
      // Adjust the structure here to match what DoctorDetailScreen expects
      final doctorDetails = {
        'name': doctor['name'],
        'specialty': doctor['specialty'],
        'phone': doctor['contactInfo']['phone'],
        'gender': doctor['contactInfo']['gender'],
      };
      emit(DoctorLoaded(doctorDetails));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onAddDoctor(AddDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      await apiService.createDoctor(event.doctorData);
      add(FetchAllDoctors()); // Refresh the list of doctors
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onDeleteDoctor(
      DeleteDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      await apiService.deleteDoctor(event.id);
      add(FetchAllDoctors()); // Refresh the list of doctors
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
