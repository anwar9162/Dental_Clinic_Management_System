// doctor_detail_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';
import '../../../services/doctor_api_service.dart';

class DoctorDetailBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorApiService apiService;

  DoctorDetailBloc(this.apiService) : super(DoctorInitial()) {
    on<FetchDoctorById>(_onFetchDoctorById);
    on<UpdateDoctor>(_onUpdateDoctor);
  }

  Future<void> _onFetchDoctorById(
      FetchDoctorById event, Emitter<DoctorState> emit) async {
    emit(DoctorDetailLoading());
    try {
      final doctor = await apiService.getDoctorById(event.id);
      final doctorDetails = {
        'name': doctor['name'],
        'specialty': doctor['specialty'],
        'phone': doctor['contactInfo']['phone'],
        'gender': doctor['contactInfo']['gender'],
        'address': doctor['contactInfo']['address'],
        'username': doctor['username'],
      };
      emit(DoctorDetailLoaded(doctorDetails));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> _onUpdateDoctor(
      UpdateDoctor event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading()); // Emit loading state while updating
    try {
      await apiService.updateDoctor(event.id, event.doctorData);
      // Fetch the updated details after updating
      final updatedDoctor = await apiService.getDoctorById(event.id);
      final doctorDetails = {
        'name': updatedDoctor['name'],
        'specialty': updatedDoctor['specialty'],
        'phone': updatedDoctor['contactInfo']['phone'],
        'gender': updatedDoctor['contactInfo']['gender'],
        'address': updatedDoctor['contactInfo']['address'],
        'username': updatedDoctor['username'],
      };
      emit(DoctorDetailLoaded(doctorDetails));
      emit(DoctorUpdated()); // Emit updated state after successful update
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
