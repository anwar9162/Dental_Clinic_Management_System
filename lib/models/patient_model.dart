// patient_model.dart

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
  final DateTime date;
  final String? reason;
  final ChiefComplaint? chiefComplaint;
  final HPI? historyOfPresentIllness;
  final PhysicalExamination physicalExamination;
  final GeneralAppearance generalAppearance;
  final ExtraOral? extraOral;
  final InternalOral internalOral;
  final Diagnosis? diagnosis;
  final TreatmentPlan? treatmentPlan;
  final TreatmentDone? treatmentDone;
  final List<ProgressNote>? progressNotes;
  final Payment? payment;

  Visit({
    required this.date,
    this.reason,
    this.chiefComplaint,
    this.historyOfPresentIllness,
    required this.physicalExamination,
    required this.generalAppearance,
    this.extraOral,
    required this.internalOral,
    this.diagnosis,
    this.treatmentPlan,
    this.treatmentDone,
    this.progressNotes,
    this.payment,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      date: DateTime.parse(json['date']),
      reason: json['reason'],
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
      internalOral: InternalOral.fromJson(json['internalOral']),
      diagnosis: json['diagnosis'] != null
          ? Diagnosis.fromJson(json['diagnosis'])
          : null,
      treatmentPlan: json['treatmentPlan'] != null
          ? TreatmentPlan.fromJson(json['treatmentPlan'])
          : null,
      treatmentDone: json['treatmentDone'] != null
          ? TreatmentDone.fromJson(json['treatmentDone'])
          : null,
      progressNotes: (json['progressNotes'] as List<dynamic>?)
          ?.map((item) => ProgressNote.fromJson(item as Map<String, dynamic>))
          .toList(),
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'reason': reason,
      'chiefComplaint': chiefComplaint?.toJson(),
      'historyOfPresentIllness': historyOfPresentIllness?.toJson(),
      'physicalExamination': physicalExamination.toJson(),
      'generalAppearance': generalAppearance.toJson(),
      'extraOral': extraOral?.toJson(),
      'internalOral': internalOral.toJson(),
      'diagnosis': diagnosis?.toJson(),
      'treatmentPlan': treatmentPlan?.toJson(),
      'treatmentDone': treatmentDone?.toJson(),
      'progressNotes': progressNotes?.map((note) => note.toJson()).toList(),
      'payment': payment?.toJson(),
    };
  }
}

class ChiefComplaint {
  final String description;
  final String duration;
  final String severity;

  ChiefComplaint({
    required this.description,
    required this.duration,
    required this.severity,
  });

  factory ChiefComplaint.fromJson(Map<String, dynamic> json) {
    return ChiefComplaint(
      description: json['description'],
      duration: json['duration'],
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'duration': duration,
      'severity': severity,
    };
  }
}

class HPI {
  final String onset;
  final String progression;
  final String associatedSymptoms;

  HPI({
    required this.onset,
    required this.progression,
    required this.associatedSymptoms,
  });

  factory HPI.fromJson(Map<String, dynamic> json) {
    return HPI(
      onset: json['onset'],
      progression: json['progression'],
      associatedSymptoms: json['associatedSymptoms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onset': onset,
      'progression': progression,
      'associatedSymptoms': associatedSymptoms,
    };
  }
}

class PhysicalExamination {
  final String bloodPressure;
  final String temperature;
  final String pulse;
  final String respirationRate;

  PhysicalExamination({
    required this.bloodPressure,
    required this.temperature,
    required this.pulse,
    required this.respirationRate,
  });

  factory PhysicalExamination.fromJson(Map<String, dynamic> json) {
    return PhysicalExamination(
      bloodPressure: json['bloodPressure'],
      temperature: json['temperature'],
      pulse: json['pulse'],
      respirationRate: json['respirationRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodPressure': bloodPressure,
      'temperature': temperature,
      'pulse': pulse,
      'respirationRate': respirationRate,
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

class InternalOral {
  final String findings;

  InternalOral({
    required this.findings,
  });

  factory InternalOral.fromJson(Map<String, dynamic> json) {
    return InternalOral(
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
  final String? followUpInstructions;

  TreatmentPlan({
    required this.plannedTreatments,
    this.followUpInstructions,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      plannedTreatments: List<String>.from(json['plannedTreatments']),
      followUpInstructions: json['followUpInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plannedTreatments': plannedTreatments,
      'followUpInstructions': followUpInstructions,
    };
  }
}

class TreatmentDone {
  final List<String> treatments;
  final DateTime? completionDate;

  TreatmentDone({
    required this.treatments,
    this.completionDate,
  });

  factory TreatmentDone.fromJson(Map<String, dynamic> json) {
    return TreatmentDone(
      treatments: List<String>.from(json['treatments']),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatments': treatments,
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
    };
  }
}
