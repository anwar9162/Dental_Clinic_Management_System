import 'dart:convert';

class Note {
  String content;
  DateTime createdAt;

  Note({required this.content, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Appointment {
  final String id;
  final String? patientName; // Add this line
  final String? patient;
  final DateTime date;
  final String? doctorName;
  final String? doctorid;
  final String? doctor;
  final String? appointmentReason;
  final List<Note>? notes;
  final DateTime? firstVisitDate;
  final String? lastTreatment;
  final String? currentAppointmentReason;

  Appointment({
    required this.id,
    this.patientName, // Add this line
    this.patient,
    required this.date,
    this.doctorName,
    this.doctorid,
    this.doctor,
    this.appointmentReason,
    this.notes,
    this.firstVisitDate,
    this.lastTreatment,
    this.currentAppointmentReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName, // Add this line
      'patient': patient,
      'date': date.toIso8601String(),
      'doctorName': doctorName,
      'doctorid': doctorid,
      'doctor': doctor,
      'appointmentReason': appointmentReason,
      'notes': notes?.map((note) => note.toJson()).toList(),
      'firstVisitDate': firstVisitDate?.toIso8601String(),
      'lastTreatment': lastTreatment,
      'currentAppointmentReason': currentAppointmentReason,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'],
      patientName: json['patientName'], // Add this line
      patient: json['patient'], // Add this line
      date: DateTime.parse(json['date']),
      doctorName: json['doctorName'],
      doctorid: json['doctorid'], // Make sure this matches your JSON structure
      doctor: json['doctor'],
      appointmentReason: json['appointmentReason'],
      notes: json['notes'] != null
          ? List<Note>.from(json['notes'].map((note) => Note.fromJson(note)))
          : null,
      firstVisitDate: json['firstVisitDate'] != null
          ? DateTime.parse(json['firstVisitDate'])
          : null,
      lastTreatment: json['lastTreatment'],
      currentAppointmentReason: json['currentAppointmentReason'],
    );
  }
}
