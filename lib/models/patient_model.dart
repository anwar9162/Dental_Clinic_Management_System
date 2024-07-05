class Patient {
  final String id;
  final String name;
  final DateTime firstVisitDate;
  final String? lastTreatment;
  final String currentAppointmentReason;

  Patient({
    required this.id,
    required this.name,
    required this.firstVisitDate,
    this.lastTreatment,
    required this.currentAppointmentReason,
  });
}
