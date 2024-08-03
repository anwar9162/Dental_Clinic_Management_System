// patient_model.dart

class Tooth {
  final int number;
  String notes;
  final bool isUpper; // true for upper teeth, false for lower teeth
  final String type; // e.g., incisor, canine, premolar, molar

  Tooth({
    required this.number,
    required this.notes,
    required this.isUpper,
    required this.type,
  });
}

class PatientImage {
  final DateTime dateCaptured;
  final String assetPath; // Path to the asset image

  PatientImage({
    required this.dateCaptured,
    required this.assetPath,
  });
}

class Patient {
  final String id;
  final String name;
  final DateTime firstVisitDate;
  final String? lastTreatment;
  final String currentAppointmentReason;
  final List<Tooth>? dentalChart;
  final List<PatientImage>?
      progressImages; // Optional: Images showing the progress of teeth
  final List<PatientImage>? xrayImages; // Optional: X-ray images

  Patient({
    required this.id,
    required this.name,
    required this.firstVisitDate,
    this.lastTreatment,
    required this.currentAppointmentReason,
    this.dentalChart,
    this.progressImages,
    this.xrayImages,
  });
}

// Sample data with image assets
final Patient mockPatient = Patient(
  id: "12",
  name: "Kibrom Adinew",
  firstVisitDate: DateTime(2023, 1, 15),
  lastTreatment: "Filling",
  currentAppointmentReason: "Routine Check-up",
  dentalChart: [
    Tooth(number: 1, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 2, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 3, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 4, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 5, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 6, notes: "Needs filling", isUpper: true, type: "Canine"),
    Tooth(number: 7, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 8, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 9, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 10, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 11, notes: "No issues", isUpper: true, type: "Canine"),
    Tooth(number: 12, notes: "Needs filling", isUpper: true, type: "Premolar"),
    Tooth(number: 13, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 14, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 15, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 16, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 17, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 18, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 19, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 20, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 21, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 22, notes: "Needs filling", isUpper: false, type: "Canine"),
    Tooth(number: 23, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 24, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 25, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 26, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 27, notes: "No issues", isUpper: false, type: "Canine"),
    Tooth(number: 28, notes: "Needs filling", isUpper: false, type: "Premolar"),
    Tooth(number: 29, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 30, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 31, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 32, notes: "Needs filling", isUpper: false, type: "Molar"),
  ],
  progressImages: [
    PatientImage(
        dateCaptured: DateTime(2023, 1, 15),
        assetPath: "assets/images/Teeth-month-1.jpg"),
  ],
  xrayImages: [
    PatientImage(
        dateCaptured: DateTime(2023, 1, 15),
        assetPath: "assets/images/Xray1.jpg"),
    PatientImage(
        dateCaptured: DateTime(2023, 6, 15),
        assetPath: "assets/images/Xray2.jpg"),
  ],
);

final Patient anotherMockPatient = Patient(
  id: "13",
  name: "Anwar Ahmed",
  firstVisitDate: DateTime(2022, 11, 20),
  lastTreatment: "Extraction",
  currentAppointmentReason: "Follow-up",
  dentalChart: [
    Tooth(number: 1, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 2, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 3, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 4, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 5, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 6, notes: "Needs filling", isUpper: true, type: "Canine"),
    Tooth(number: 7, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 8, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 9, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 10, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 11, notes: "No issues", isUpper: true, type: "Canine"),
    Tooth(number: 12, notes: "Needs filling", isUpper: true, type: "Premolar"),
    Tooth(number: 13, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 14, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 15, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 16, notes: "Needs filling", isUpper: true, type: "Molar"),
    Tooth(number: 17, notes: "Needs filling", isUpper: false, type: "Molar"),
    Tooth(number: 18, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 19, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 20, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 21, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 22, notes: "Needs filling", isUpper: false, type: "Canine"),
    Tooth(number: 23, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 24, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 25, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 26, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 27, notes: "No issues", isUpper: false, type: "Canine"),
    Tooth(number: 28, notes: "Needs filling", isUpper: false, type: "Premolar"),
    Tooth(number: 29, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 30, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 31, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 32, notes: "Needs filling", isUpper: false, type: "Molar"),
  ],
  progressImages: [
    PatientImage(
        dateCaptured: DateTime(2022, 11, 20),
        assetPath: "assets/images/Teeth-month-1.jpg"),
    PatientImage(
        dateCaptured: DateTime(2023, 5, 20),
        assetPath: "assets/images/Teeth-month-1.jpg"),
  ],
  xrayImages: [
    PatientImage(
        dateCaptured: DateTime(2022, 11, 20),
        assetPath: "assets/images/Xray1.jpg"),
  ],
);

final Patient anotherMockPatient3 = Patient(
  id: "14",
  name: "Abraham Worku",
  firstVisitDate: DateTime(2024, 8, 13),
  lastTreatment: "Brace",
  currentAppointmentReason: "Follow-up",
  dentalChart: [
    Tooth(number: 1, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 2, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 3, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 4, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 5, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 6, notes: "No issues", isUpper: true, type: "Canine"),
    Tooth(number: 7, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 8, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 9, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 10, notes: "No issues", isUpper: true, type: "Incisor"),
    Tooth(number: 11, notes: "No issues", isUpper: true, type: "Canine"),
    Tooth(number: 12, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 13, notes: "No issues", isUpper: true, type: "Premolar"),
    Tooth(number: 14, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 15, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 16, notes: "No issues", isUpper: true, type: "Molar"),
    Tooth(number: 17, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 18, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 19, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 20, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 21, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 22, notes: "No issues", isUpper: false, type: "Canine"),
    Tooth(number: 23, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 24, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 25, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 26, notes: "No issues", isUpper: false, type: "Incisor"),
    Tooth(number: 27, notes: "No issues", isUpper: false, type: "Canine"),
    Tooth(number: 28, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 29, notes: "No issues", isUpper: false, type: "Premolar"),
    Tooth(number: 30, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 31, notes: "No issues", isUpper: false, type: "Molar"),
    Tooth(number: 32, notes: "No issues", isUpper: false, type: "Molar"),
  ],
  progressImages: [
    PatientImage(
        dateCaptured: DateTime(2024, 8, 13),
        assetPath: "assets/images/Teeth-month-1.jpg"),
  ],
  xrayImages: [
    PatientImage(
        dateCaptured: DateTime(2024, 8, 13),
        assetPath: "assets/images/Xray1.jpg"),
  ],
);

final List<Patient> mockPatients = [
  mockPatient,
  anotherMockPatient,
  anotherMockPatient3,
];
