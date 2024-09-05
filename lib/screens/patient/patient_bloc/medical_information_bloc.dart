// bloc/medical_information_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../services/patient_api_service.dart';
import '../../../models/patient_model.dart';
import '../../../models/basic_patient_info_model.dart';
import 'medical_information_event.dart';
import 'medical_information_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/patient_api_service.dart';

class MedicalInformationBloc
    extends Bloc<MedicalInformationEvent, MedicalInformationState> {
  final PatientApiService apiService;

  MedicalInformationBloc(this.apiService) : super(MedicalInformationInitial()) {
    on<FetchPatients>(_onFetchPatients);
    on<FetchBasicPatientInfo>(_onFetchBasicPatientInfo);
  }

  Future<void> _onFetchPatients(
      FetchPatients event, Emitter<MedicalInformationState> emit) async {
    emit(MedicalInformationLoading());
    try {
      final patientsJson = await apiService.getAllPatients();
      final patients =
          patientsJson.map((json) => Patient.fromJson(json)).toList();
      emit(MedicalInformationLoaded(patients));
    } catch (e) {
      emit(MedicalInformationError(e.toString()));
    }
  }

  Future<void> _onFetchBasicPatientInfo(FetchBasicPatientInfo event,
      Emitter<MedicalInformationState> emit) async {
    emit(MedicalInformationLoading());
    try {
      final basicInfoJson = await apiService.getPatientsBasicInfo();
      final basicPatientInfo =
          basicInfoJson.map((json) => PatientBasicInfo.fromJson(json)).toList();
      emit(MedicalInformationBasicInfoLoaded(basicPatientInfo));
    } catch (e) {
      emit(MedicalInformationError(e.toString()));
    }
  }
}
