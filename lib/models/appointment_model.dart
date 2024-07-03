class Appointment {
  final String id;
  final String patientName;
  final String doctorName;
  final DateTime date;
  final String time;
  final String description;

  Appointment({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.description,
  });
}
