// bloc/medical_information_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/patient_api_service.dart';
import '../../../models/patient_model.dart';
import 'medical_information_event.dart';
import 'medical_information_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/patient_api_service.dart';

class MedicalInformationBloc
    extends Bloc<MedicalInformationEvent, MedicalInformationState> {
  final PatientApiService apiService;

  MedicalInformationBloc(this.apiService) : super(MedicalInformationInitial()) {
    on<FetchPatients>(_onFetchPatients);
  }

  Future<void> _onFetchPatients(
      FetchPatients event, Emitter<MedicalInformationState> emit) async {
    emit(MedicalInformationLoading());
    try {
      final patientsJson = await apiService.getAllPatients();
      final patients = patientsJson
          .map((json) => Patient(
              id: json['_id'],
              firstName: json['firstName'],
              lastName: json['lastName'],
              phoneNumber: json['phoneNumber']))
          .toList();
      emit(MedicalInformationLoaded(patients));
    } catch (e) {
      emit(MedicalInformationError(e.toString()));
    }
  }
}
