class Appointment {
  final String id;
  final String patientName;
  final DateTime date;
  final String description;
  final String doctorName;

  Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.description,
    required this.doctorName,
  });
}
