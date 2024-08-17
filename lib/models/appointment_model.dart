import 'dart:convert';

class Note {
  String content;
  DateTime createdAt;

  Note({
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Appointment {
  final String? id;
  final String? patientName;
  final String? doctorName;
  final String? doctorid;
  final String? patient;
  final String? doctor;
  final PatientDetails? patientDetails;
  final DoctorDetails? doctorDetails;
  final DateTime date;
  final String? appointmentReason;
  final List<Note>? notes;

  final String? lastTreatment;
  final String? currentAppointmentReason;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Appointment({
    this.id,
    this.patientDetails,
    this.patientName,
    this.doctorName,
    this.doctorid,
    this.doctor,
    this.patient,
    this.doctorDetails,
    required this.date,
    this.appointmentReason,
    this.notes,
    this.lastTreatment,
    this.currentAppointmentReason,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientDetails': patientDetails?.toJson() ?? {},
      'doctorDetails': doctorDetails?.toJson() ?? {},
      'date': date.toIso8601String(),
      'patient': patient,
      'doctor': doctor,
      'appointmentReason': appointmentReason,
      'notes': notes?.map((note) => note.toJson()).toList() ?? [],
      'lastTreatment': lastTreatment,
      'currentAppointmentReason': currentAppointmentReason,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] as String? ?? '',
      patientDetails: json['patient'] != null
          ? PatientDetails.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      doctorDetails: json['doctor'] != null
          ? DoctorDetails.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      date: DateTime.tryParse(
              json['date'] as String? ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      appointmentReason: json['appointmentReason'] as String?,
      notes: json['notes'] != null
          ? List<Note>.from((json['notes'] as List)
              .map((note) => Note.fromJson(note as Map<String, dynamic>)))
          : [],
      lastTreatment: json['lastTreatment'] as String?,
      currentAppointmentReason: json['currentAppointmentReason'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? null
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? null
          : null,
    );
  }
}

class PatientDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final DateTime dateOfBirth;
  final String address;
  final List<dynamic> visitHistory;
  final List<dynamic> medicalHistory;
  final List<dynamic> dentalChart;
  final List<dynamic> payments;
  final List<dynamic> progressImages;
  final List<dynamic> xrayImages;

  PatientDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.visitHistory,
    required this.medicalHistory,
    required this.dentalChart,
    required this.payments,
    required this.progressImages,
    required this.xrayImages,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'visitHistory': visitHistory,
      'medicalHistory': medicalHistory,
      'dentalChart': dentalChart,
      'payments': payments,
      'progressImages': progressImages,
      'xrayImages': xrayImages,
    };
  }

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      id: json['_id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      dateOfBirth: DateTime.tryParse(json['dateOfBirth'] as String? ??
              DateTime.now().toIso8601String()) ??
          DateTime.now(),
      address: json['address'] as String? ?? '',
      visitHistory: List<dynamic>.from(json['visitHistory'] as List? ?? []),
      medicalHistory: List<dynamic>.from(json['medicalHistory'] as List? ?? []),
      dentalChart: List<dynamic>.from(json['dentalChart'] as List? ?? []),
      payments: List<dynamic>.from(json['payments'] as List? ?? []),
      progressImages: List<dynamic>.from(json['progressImages'] as List? ?? []),
      xrayImages: List<dynamic>.from(json['xrayImages'] as List? ?? []),
    );
  }
}

class DoctorDetails {
  final String id;
  final String name;
  final String specialty;
  final ContactInfo contactInfo;

  DoctorDetails({
    required this.id,
    required this.name,
    required this.specialty,
    required this.contactInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'specialty': specialty,
      'contactInfo': contactInfo.toJson(),
    };
  }

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      contactInfo: ContactInfo.fromJson(
          json['contactInfo'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ContactInfo {
  final String phone;
  final String gender;
  final String address;

  ContactInfo({
    required this.phone,
    required this.gender,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'gender': gender,
      'address': address,
    };
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}
