import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';
import '../../../services/doctor_api_service.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorApiService apiService;

  DoctorBloc(this.apiService) : super(DoctorInitial()) {
    on<FetchAllDoctors>(_onFetchAllDoctors);
    on<AddDoctor>(_onAddDoctor);
    on<DeleteDoctor>(_onDeleteDoctor);
    on<FetchDoctorById>(
        _onFetchDoctorById); // Add this to fetch a single doctor
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

  Future<void> _onAddDoctor(AddDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading()); // Emit loading state
    try {
      await apiService.createDoctor(event.doctorData);
      final doctors = await apiService.getAllDoctors();
      emit(DoctorAdded()); // Emit success state
      emit(DoctorsLoaded(doctors)); // Refresh doctor list
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onDeleteDoctor(
      DeleteDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      await apiService.deleteDoctor(event.id);
      emit(DoctorDeleteSuccess());
      add(FetchAllDoctors()); // Refresh doctor list
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onFetchDoctorById(
      FetchDoctorById event, Emitter<DoctorState> emit) async {
    emit(DoctorDetailLoading());
    try {
      final doctor = await apiService.getDoctorById(event.id);
      emit(DoctorDetailLoaded(doctor));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
