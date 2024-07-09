import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart' as custom;
import '../../models/patient_model.dart';
import '../../widgets/dental_chart.dart';

class PatientDetailScreen extends StatelessWidget {
  final String name;
  final DateTime? firstVisitDate;
  final String? lastTreatment;
  final String currentAppointmentReason;

  PatientDetailScreen({
    required this.name,
    this.firstVisitDate,
    this.lastTreatment,
    required this.currentAppointmentReason,
  });

  @override
  Widget build(BuildContext context) {
    DateTime visitDate = firstVisitDate ?? DateTime.now();
    int daysSinceFirstVisit = DateTime.now().difference(visitDate).inDays;

    final mockPatient = Patient(
      id: "12",
      name: name,
      firstVisitDate: visitDate,
      lastTreatment: lastTreatment ?? "No treatment",
      currentAppointmentReason: currentAppointmentReason,
      dentalChart: List.generate(
        32,
        (index) => Tooth(
          number: index + 1,
          notes: "No issues",
          isUpper: index < 16,
          type: _getToothType(index + 1),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${mockPatient.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'First Visit Date: ${visitDate.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Last Treatment: ${mockPatient.lastTreatment}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Current Appointment Reason: ${mockPatient.currentAppointmentReason}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Days Since First Visit: $daysSinceFirstVisit',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Dental Chart:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DentalChart(dentalChart: mockPatient.dentalChart!),
            ],
          ),
        ),
      ),
    );
  }

  String _getToothType(int number) {
    if ((number >= 7 && number <= 10) || (number >= 23 && number <= 26)) {
      return "Incisor";
    } else if ((number >= 1 && number <= 3) ||
        (number >= 14 && number <= 19) ||
        (number >= 30 && number <= 32)) {
      return "Molar";
    } else if ((number == 4 ||
        number == 5 ||
        number == 12 ||
        number == 13 ||
        number == 20 ||
        number == 21 ||
        number == 28 ||
        number == 29)) {
      return "Premolar";
    } else if (number == 6 || number == 11 || number == 22 || number == 27) {
      return "Canine";
    } else {
      return "Unknown"; // Handle any unexpected numbers gracefully
    }
  }
}
