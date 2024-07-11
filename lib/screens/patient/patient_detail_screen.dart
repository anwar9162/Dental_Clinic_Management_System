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
              _buildPatientInfoSection(mockPatient, daysSinceFirstVisit),
              SizedBox(height: 20),
              _buildDentalChartSection(mockPatient.dentalChart!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection(Patient patient, int daysSinceFirstVisit) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow('First Visit Date:',
                      '${patient.firstVisitDate.toLocal()}'.split(' ')[0]),
                  _buildInfoRow('Last Treatment:',
                      patient.lastTreatment ?? "No treatment"),
                  _buildInfoRow('Current Appointment Reason:',
                      patient.currentAppointmentReason),
                  _buildInfoRow(
                      'Days Since First Visit:', '$daysSinceFirstVisit'),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/user_profile_image.jpg',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDentalChartSection(List<Tooth> dentalChart) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dental Chart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            DentalChart(dentalChart: dentalChart),
          ],
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
