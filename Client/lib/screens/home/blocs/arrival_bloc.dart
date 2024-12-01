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
    on<DeleteArrivalEvent>(_onDeleteArrival); // Handle delete event
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
      add(LoadArrivalsEvent()); // Refresh the list of arrivals after marking a patient as arrived
    } catch (e) {
      print('Error marking patient as arrived: ${e.toString()}');
      emit(ArrivalErrorState(
          'Failed to mark patient as arrived. Please try again.'));
    }
  }

  Future<void> _onLoadArrivals(
      LoadArrivalsEvent event, Emitter<ArrivalState> emit) async {
    emit(ArrivalLoadingState());
    try {
      final arrivalsJson = await arrivalService.gettodayArrivals();
      print('Raw arrivals JSON: $arrivalsJson'); // Debug log

      final arrivals = arrivalsJson
          .map((json) => Arrival.fromJson(json as Map<String, dynamic>))
          .toList();

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
      emit(ArrivalErrorState('Failed to load arrivals. Please try again.'));
    }
  }

  Future<void> _onDeleteArrival(
      DeleteArrivalEvent event, Emitter<ArrivalState> emit) async {
    emit(ArrivalLoadingState());
    try {
      await arrivalService.deleteArrival(event.arrivalId);
      print('Arrival deleted: ${event.arrivalId}');
      add(LoadArrivalsEvent()); // Refresh the list of arrivals after deletion
    } catch (e) {
      print('Error deleting arrival: ${e.toString()}');
      emit(ArrivalErrorState('Failed to delete arrival. Please try again.'));
    }
  }
}
