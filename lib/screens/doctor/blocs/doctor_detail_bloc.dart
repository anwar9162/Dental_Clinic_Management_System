import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';
import '../../../services/doctor_api_service.dart';

class DoctorDetailBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorApiService apiService;

  DoctorDetailBloc(this.apiService) : super(DoctorInitial()) {
    on<FetchDoctorById>(_onFetchDoctorById);
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
      };
      emit(DoctorDetailLoaded(doctorDetails));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
