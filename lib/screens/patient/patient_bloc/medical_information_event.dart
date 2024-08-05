// events/medical_information_event.dart
import 'package:equatable/equatable.dart';

abstract class MedicalInformationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPatients extends MedicalInformationEvent {}
