// arrival_model.dart

import 'package:equatable/equatable.dart';
import '../../../models/patient_model.dart'; // Import the Patient model

class Arrival extends Equatable {
  final String id;
  final Patient patient;
  final DateTime arrivalTime;
  final String? notes;
  final String arrivalType;

  Arrival({
    required this.id,
    required this.patient,
    required this.arrivalTime,
    this.notes,
    required this.arrivalType,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) {
    try {
      return Arrival(
        id: json['_id'] as String,
        patient: json['patientId'] != null
            ? Patient.fromJson(json['patientId'] as Map<String, dynamic>)
            : Patient(
                id: null,
                firstName: '',
                lastName: '',
                phoneNumber: '', // Provide default value if necessary
              ),
        arrivalTime: json['arrivalTime'] != null
            ? DateTime.parse(json['arrivalTime'] as String)
            : DateTime.now(),
        notes: json['notes'] as String?,
        arrivalType: json['arrivalType'] as String? ?? '',
      );
    } catch (e) {
      print('Error parsing Arrival: ${e.toString()}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patient.toJson(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'notes': notes,
      'arrivalType': arrivalType,
    };
  }

  @override
  List<Object?> get props => [id, patient, arrivalTime, notes, arrivalType];
}
