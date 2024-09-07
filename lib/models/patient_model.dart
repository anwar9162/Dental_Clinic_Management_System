import 'dart:convert';

class PatientImage {
  final DateTime dateCaptured;
  final String assetPath;

  PatientImage({
    required this.dateCaptured,
    required this.assetPath,
  });

  factory PatientImage.fromJson(Map<String, dynamic> json) {
    return PatientImage(
      dateCaptured: DateTime.parse(json['dateCaptured']),
      assetPath: json['assetPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateCaptured': dateCaptured.toIso8601String(),
      'assetPath': assetPath,
    };
  }
}

class CardStatus {
  final bool isActive;
  final DateTime? expirationDate;
  final String? notes;

  CardStatus({
    required this.isActive,
    this.expirationDate,
    this.notes,
  });

  factory CardStatus.fromJson(Map<String, dynamic> json) {
    return CardStatus(
      isActive: json['isActive'],
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'expirationDate': expirationDate?.toIso8601String(),
      'notes': notes,
    };
  }
}

class Visit {
  final String? id;
  final DateTime date;
  final ChiefComplaint? chiefComplaint;
  final HPI? historyOfPresentIllness;
  final PhysicalExamination? physicalExamination;
  final GeneralAppearance? generalAppearance;
  final ExtraOral? extraOral;
  final IntraOral intraOral;
  final Diagnosis? diagnosis;
  final TreatmentPlan? treatmentPlan;
  final List<TreatmentEntry>? treatmentDone;
  final List<ProgressNote>? progressNotes;
  final Payment? payment;
  final List<PastMedicalHistory>? pastMedicalHistory; // Added
  final List<PastDentalHistory>? pastDentalHistory; // Added

  Visit({
    this.id,
    required this.date,
    this.chiefComplaint,
    this.historyOfPresentIllness,
    this.physicalExamination,
    this.generalAppearance,
    this.extraOral,
    required this.intraOral,
    this.diagnosis,
    this.treatmentPlan,
    this.treatmentDone,
    this.progressNotes,
    this.payment,
    this.pastMedicalHistory, // Added
    this.pastDentalHistory, // Added
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      chiefComplaint: json['chiefComplaint'] != null
          ? ChiefComplaint.fromJson(json['chiefComplaint'])
          : null,
      historyOfPresentIllness: json['historyOfPresentIllness'] != null
          ? HPI.fromJson(json['historyOfPresentIllness'])
          : null,
      physicalExamination:
          PhysicalExamination.fromJson(json['physicalExamination']),
      generalAppearance: GeneralAppearance.fromJson(json['generalAppearance']),
      extraOral: json['extraOral'] != null
          ? ExtraOral.fromJson(json['extraOral'])
          : null,
      intraOral: IntraOral.fromJson(json['intraOral']),
      diagnosis: json['diagnosis'] != null
          ? Diagnosis.fromJson(json['diagnosis'])
          : null,
      treatmentPlan: json['treatmentPlan'] != null
          ? TreatmentPlan.fromJson(json['treatmentPlan'])
          : null,
      treatmentDone: (json['treatmentDone'] as List<dynamic>?)
          ?.map((item) => TreatmentEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
      progressNotes: (json['progressNotes'] as List<dynamic>?)
          ?.map((item) => ProgressNote.fromJson(item as Map<String, dynamic>))
          .toList(),
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      pastMedicalHistory: (json['pastMedicalHistory'] as List<dynamic>?)
          ?.map((item) =>
              PastMedicalHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
      pastDentalHistory: (json['pastDentalHistory'] as List<dynamic>?)
          ?.map((item) =>
              PastDentalHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'chiefComplaint': chiefComplaint?.toJson(),
      'historyOfPresentIllness': historyOfPresentIllness?.toJson(),
      'physicalExamination': physicalExamination?.toJson(),
      'generalAppearance': generalAppearance?.toJson(),
      'extraOral': extraOral?.toJson(),
      'intraOral': intraOral.toJson(),
      'diagnosis': diagnosis?.toJson(),
      'treatmentPlan': treatmentPlan?.toJson(),
      'treatmentDone': treatmentDone?.map((entry) => entry.toJson()).toList(),
      'progressNotes': progressNotes?.map((note) => note.toJson()).toList(),
      'payment': payment?.toJson(),
      'pastMedicalHistory':
          pastMedicalHistory?.map((history) => history.toJson()).toList(),
      'pastDentalHistory':
          pastDentalHistory?.map((history) => history.toJson()).toList(),
    };
  }
}

class ChiefComplaint {
  final String? description;

  ChiefComplaint({
    this.description,
  });

  factory ChiefComplaint.fromJson(Map<String, dynamic> json) {
    return ChiefComplaint(
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}

class HPI {
  final String? Detail;

  HPI({
    this.Detail,
  });

  factory HPI.fromJson(Map<String, dynamic> json) {
    return HPI(
      Detail: json['Detail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Detail': Detail,
    };
  }
}

class PhysicalExamination {
  final String? bloodPressure;
  final String? temperature;
  final String? pulse;

  PhysicalExamination({
    this.bloodPressure,
    this.temperature,
    this.pulse,
  });

  factory PhysicalExamination.fromJson(Map<String, dynamic> json) {
    return PhysicalExamination(
      bloodPressure: json['bloodPressure'],
      temperature: json['temperature'],
      pulse: json['pulse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodPressure': bloodPressure,
      'temperature': temperature,
      'pulse': pulse,
    };
  }
}

class GeneralAppearance {
  final String appearance;
  final String? additionalNotes;

  GeneralAppearance({
    required this.appearance,
    this.additionalNotes,
  });

  factory GeneralAppearance.fromJson(Map<String, dynamic> json) {
    return GeneralAppearance(
      appearance: json['appearance'],
      additionalNotes: json['additionalNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appearance': appearance,
      'additionalNotes': additionalNotes,
    };
  }
}

class ExtraOral {
  final String findings;

  ExtraOral({
    required this.findings,
  });

  factory ExtraOral.fromJson(Map<String, dynamic> json) {
    return ExtraOral(
      findings: json['findings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'findings': findings,
    };
  }
}

class IntraOral {
  final String findings;

  IntraOral({
    required this.findings,
  });

  factory IntraOral.fromJson(Map<String, dynamic> json) {
    return IntraOral(
      findings: json['findings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'findings': findings,
    };
  }
}

class Diagnosis {
  final String condition;
  final String details;

  Diagnosis({
    required this.condition,
    required this.details,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      condition: json['condition'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'details': details,
    };
  }
}

class TreatmentPlan {
  final List<String> plannedTreatments;

  TreatmentPlan({
    required this.plannedTreatments,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      plannedTreatments: List<String>.from(json['plannedTreatments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plannedTreatments': plannedTreatments,
    };
  }
}

class TreatmentEntry {
  final String treatment;
  final DateTime? completionDate;

  TreatmentEntry({
    required this.treatment,
    this.completionDate,
  });

  factory TreatmentEntry.fromJson(Map<String, dynamic> json) {
    return TreatmentEntry(
      treatment: json['treatment'],
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment': treatment,
      'completionDate': completionDate?.toIso8601String(),
    };
  }
}

class ProgressNote {
  final String note;
  final DateTime createdAt;

  ProgressNote({
    required this.note,
    required this.createdAt,
  });

  factory ProgressNote.fromJson(Map<String, dynamic> json) {
    return ProgressNote(
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Payment {
  final double amount;
  final DateTime date;
  final String status;
  final String? reason;

  Payment({
    required this.amount,
    required this.date,
    required this.status,
    this.reason,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'reason': reason,
    };
  }
}

class PastMedicalHistory {
  final String fieldName;
  final String fieldValue;
  final String? patientId;

  PastMedicalHistory({
    required this.fieldName,
    required this.fieldValue,
    this.patientId,
  });

  factory PastMedicalHistory.fromJson(Map<String, dynamic> json) {
    return PastMedicalHistory(
      fieldName: json['fieldName'],
      fieldValue: json['fieldValue'],
      patientId: json['patientId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'fieldValue': fieldValue,
      'patientId': patientId,
    };
  }
}

class PastDentalHistory {
  final String fieldName;
  final String fieldValue;

  PastDentalHistory({
    required this.fieldName,
    required this.fieldValue,
  });

  factory PastDentalHistory.fromJson(Map<String, dynamic> json) {
    return PastDentalHistory(
      fieldName: json['fieldName'],
      fieldValue: json['fieldValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'fieldValue': fieldValue,
    };
  }
}

class Patient {
  final String? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final CardStatus? cardStatus;
  final List<Visit>? visitHistory;
  final List<PatientImage>? progressImages;
  final List<PatientImage>? xrayImages;
  final List<PastMedicalHistory>? pastMedicalHistory;
  final List<PastDentalHistory>? pastDentalHistory;

  Patient({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.cardStatus,
    this.visitHistory,
    this.progressImages,
    this.xrayImages,
    this.pastMedicalHistory,
    this.pastDentalHistory,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      address: json['address'],
      cardStatus: json['cardStatus'] != null
          ? CardStatus.fromJson(json['cardStatus'])
          : null,
      visitHistory: (json['visitHistory'] as List<dynamic>?)
          ?.map((item) => Visit.fromJson(item as Map<String, dynamic>))
          .toList(),
      progressImages: (json['progressImages'] as List<dynamic>?)
          ?.map((item) => PatientImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      xrayImages: (json['xrayImages'] as List<dynamic>?)
          ?.map((item) => PatientImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      pastMedicalHistory: (json['pastMedicalHistory'] as List<dynamic>?)
          ?.map((item) =>
              PastMedicalHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
      pastDentalHistory: (json['pastDentalHistory'] as List<dynamic>?)
          ?.map((item) =>
              PastDentalHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'cardStatus': cardStatus?.toJson(),
      'visitHistory': visitHistory?.map((v) => v.toJson()).toList(),
      'progressImages': progressImages?.map((img) => img.toJson()).toList(),
      'xrayImages': xrayImages?.map((img) => img.toJson()).toList(),
      'pastMedicalHistory':
          pastMedicalHistory?.map((history) => history.toJson()).toList(),
      'pastDentalHistory':
          pastDentalHistory?.map((history) => history.toJson()).toList(),
    };
  }
}
