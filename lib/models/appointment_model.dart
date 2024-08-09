class Appointment {
  final String id;
  final String patientName;
  final DateTime date;

  final String doctorName;
  final String? appointmentReason;
  final List? notes;
  final DateTime? firstVisitDate;
  final String? lastTreatment;
  final String? currentAppointmentReason;
  Appointment(
      {required this.id,
      required this.patientName,
      required this.date,
      required this.doctorName,
      this.firstVisitDate,
      this.lastTreatment,
      this.currentAppointmentReason,
      this.appointmentReason,
      this.notes});
}
