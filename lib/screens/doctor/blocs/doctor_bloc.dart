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
    emit(DoctorLoading());
    try {
      await apiService.createDoctor(event.doctorData);
      final doctors = await apiService.getAllDoctors();
      emit(DoctorsLoaded(doctors));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onDeleteDoctor(
      DeleteDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading()); // Emit loading state while deleting
    try {
      await apiService.deleteDoctor(event.id);
      add(FetchAllDoctors()); // Fetch all doctors to refresh the list
      emit(DoctorDeleteSuccess()); // Emit success state after reload
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
