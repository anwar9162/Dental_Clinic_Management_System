// arrival_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'arrival_event.dart';
import 'arrival_state.dart';
import '../../../services/arrival_service.dart';
import '../models/arrival_model.dart'; // Import the Arrival model

class ArrivalBloc extends Bloc<ArrivalEvent, ArrivalState> {
  final ArrivalService arrivalService;

  ArrivalBloc(this.arrivalService) : super(ArrivalInitialState()) {
    on<MarkPatientAsArrivedEvent>(_onMarkPatientAsArrived);
    on<LoadArrivalsEvent>(_onLoadArrivals);
  }

  Future<void> _onMarkPatientAsArrived(
      MarkPatientAsArrivedEvent event, Emitter<ArrivalState> emit) async {
    emit(ArrivalLoadingState());
    try {
      await arrivalService.markPatientAsArrived(
        patientId: event.patientId,
        arrivalTime: event.arrivalTime,
        notes: event.notes,
        arrivalType: event.arrivalType,
      );
      print('Patient marked as arrived: ${event.patientId}');
      // Refresh the list of arrivals after marking a patient as arrived
      add(LoadArrivalsEvent());
    } catch (e) {
      print('Error marking patient as arrived: ${e.toString()}');
      emit(ArrivalErrorState(e.toString()));
    }
  }

  Future<void> _onLoadArrivals(
      LoadArrivalsEvent event, Emitter<ArrivalState> emit) async {
    emit(ArrivalLoadingState());
    try {
      final arrivalsJson = await arrivalService.getAllArrivals();
      print('Raw arrivals JSON: $arrivalsJson'); // Debug log

      final arrivals = arrivalsJson
          .map((json) => Arrival.fromJson(json as Map<String, dynamic>))
          .toList();

      // Filter and categorize arrivals
      final onAppointmentArrivals = arrivals
          .where((arrival) => arrival.arrivalType == 'On Appointment')
          .toList();

      final walkInArrivals = arrivals
          .where((arrival) => arrival.arrivalType == 'Walk-in')
          .toList();

      emit(ArrivalLoadedState(
        onAppointmentArrivals: onAppointmentArrivals,
        walkInArrivals: walkInArrivals,
      ));
    } catch (e) {
      print('Error loading arrivals: ${e.toString()}');
      emit(ArrivalErrorState(e.toString()));
    }
  }
}
