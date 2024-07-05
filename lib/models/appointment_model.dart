class Appointment {
  final String id;
  final String patientName;
  final DateTime date;
  final String description;
  final String doctorName;
  final DateTime? firstVisitDate;
  final String? lastTreatment;
  final String? currentAppointmentReason;
  Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.description,
    required this.doctorName,
    this.firstVisitDate,
    this.lastTreatment,
    this.currentAppointmentReason,
  });
}
