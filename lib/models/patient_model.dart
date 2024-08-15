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
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? Address;
  final DateTime? firstVisitDate;
  final List<Tooth>? dentalChart;
  final List<PatientImage>?
      progressImages; // Optional: Images showing the progress of teeth
  final List<PatientImage>? xrayImages; // Optional: X-ray images

  Patient({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.Address,
    this.firstVisitDate,
    this.dentalChart,
    this.progressImages,
    this.xrayImages,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      gender: json['Gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      Address: json['Address'],
      firstVisitDate: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      dentalChart: (json['dentalChart'] as List<dynamic>?)
          ?.map((item) => Tooth(
                number: item['number'],
                notes: item['notes'],
                isUpper: item['isUpper'],
                type: item['type'],
              ))
          .toList(),
      progressImages: (json['progressImages'] as List<dynamic>?)
          ?.map((item) => PatientImage(
                dateCaptured: DateTime.parse(item['dateCaptured']),
                assetPath: item['assetPath'],
              ))
          .toList(),
      xrayImages: (json['xrayImages'] as List<dynamic>?)
          ?.map((item) => PatientImage(
                dateCaptured: DateTime.parse(item['dateCaptured']),
                assetPath: item['assetPath'],
              ))
          .toList(),
    );
  }
}

// Sample data with image assets
final Patient mockPatient = Patient(
  firstName: "Kibrom",
  lastName: "Adinew",
  phoneNumber: "0712345678",
  firstVisitDate: DateTime(2023, 1, 15),
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
  firstName: "Anwar",
  lastName: "Ahmed",
  phoneNumber: "0712345678",
  firstVisitDate: DateTime(2022, 11, 20),
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
  firstName: "Abraham",
  lastName: "Worku",
  phoneNumber: "0712345678",
  firstVisitDate: DateTime(2024, 8, 13),
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
