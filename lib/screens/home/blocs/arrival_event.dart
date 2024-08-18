import 'package:equatable/equatable.dart';

abstract class ArrivalEvent extends Equatable {
  const ArrivalEvent();

  @override
  List<Object?> get props => [];
}

class MarkPatientAsArrivedEvent extends ArrivalEvent {
  final String patientId;
  final DateTime arrivalTime;
  final String? notes;
  final String arrivalType;

  const MarkPatientAsArrivedEvent({
    required this.patientId,
    required this.arrivalTime,
    this.notes,
    required this.arrivalType,
  });

  @override
  List<Object?> get props => [patientId, arrivalTime, notes, arrivalType];
}

class LoadArrivalsEvent extends ArrivalEvent {}
