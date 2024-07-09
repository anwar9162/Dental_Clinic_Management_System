class Tooth {
  final int number;
  final String condition; // e.g., healthy, decayed, missing, etc.
  final String notes;
  final bool isUpper; // true for upper teeth, false for lower teeth
  final String type; // e.g., incisor, canine, premolar, molar

  Tooth({
    required this.number,
    required this.condition,
    required this.notes,
    required this.isUpper,
    required this.type,
  });
}

class Patient {
  final String id;
  final String name;
  final DateTime firstVisitDate;
  final String? lastTreatment;
  final String currentAppointmentReason;
  final List<Tooth>? dentalChart;

  Patient({
    required this.id,
    required this.name,
    required this.firstVisitDate,
    this.lastTreatment,
    required this.currentAppointmentReason,
    this.dentalChart,
  });
}

final mockPatient = Patient(
  id: "12",
  name: "John Doe",
  firstVisitDate: DateTime(2023, 1, 15),
  lastTreatment: "Filling",
  currentAppointmentReason: "Routine Check-up",
  dentalChart: [
    Tooth(
        number: 1,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Molar"),
    Tooth(
        number: 2,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: true,
        type: "Molar"),
    Tooth(
        number: 3,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Molar"),
    Tooth(
        number: 4,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Premolar"),
    Tooth(
        number: 5,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Premolar"),
    Tooth(
        number: 6,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: true,
        type: "Canine"),
    Tooth(
        number: 7,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Incisor"),
    Tooth(
        number: 8,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Incisor"),
    Tooth(
        number: 9,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Incisor"),
    Tooth(
        number: 10,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Incisor"),
    Tooth(
        number: 11,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Canine"),
    Tooth(
        number: 12,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: true,
        type: "Premolar"),
    Tooth(
        number: 13,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Premolar"),
    Tooth(
        number: 14,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Molar"),
    Tooth(
        number: 15,
        condition: "Healthy",
        notes: "No issues",
        isUpper: true,
        type: "Molar"),
    Tooth(
        number: 16,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: true,
        type: "Molar"),
    Tooth(
        number: 17,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Molar"),
    Tooth(
        number: 18,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Molar"),
    Tooth(
        number: 19,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Molar"),
    Tooth(
        number: 20,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Premolar"),
    Tooth(
        number: 21,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Premolar"),
    Tooth(
        number: 22,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: false,
        type: "Canine"),
    Tooth(
        number: 23,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Incisor"),
    Tooth(
        number: 24,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Incisor"),
    Tooth(
        number: 25,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Incisor"),
    Tooth(
        number: 26,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Incisor"),
    Tooth(
        number: 27,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Canine"),
    Tooth(
        number: 28,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: false,
        type: "Premolar"),
    Tooth(
        number: 29,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Premolar"),
    Tooth(
        number: 30,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Molar"),
    Tooth(
        number: 31,
        condition: "Healthy",
        notes: "No issues",
        isUpper: false,
        type: "Molar"),
    Tooth(
        number: 32,
        condition: "Decayed",
        notes: "Needs filling",
        isUpper: false,
        type: "Molar"),
  ],
);
