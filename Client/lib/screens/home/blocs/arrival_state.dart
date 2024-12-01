// arrival_state.dart
import 'package:equatable/equatable.dart';
import '../models/arrival_model.dart';

abstract class ArrivalState {}

class ArrivalInitialState extends ArrivalState {}

class ArrivalLoadingState extends ArrivalState {}

class ArrivalLoadedState extends ArrivalState {
  final List<Arrival> onAppointmentArrivals;
  final List<Arrival> walkInArrivals;

  ArrivalLoadedState({
    required this.onAppointmentArrivals,
    required this.walkInArrivals,
  });
}

class ArrivalErrorState extends ArrivalState {
  final String message;

  ArrivalErrorState(this.message);
}
