import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../widgets/dental_chart.dart'; // Ensure you have the DentalChart widget

class PatientDetailWidget extends StatelessWidget {
  final Patient patient;

  PatientDetailWidget({required this.patient});

  @override
  Widget build(BuildContext context) {
    DateTime visitDate = patient.firstVisitDate ?? DateTime.now();
    int daysSinceFirstVisit = DateTime.now().difference(visitDate).inDays;

    final mockPatient = Patient(
      id: "12",
      name: patient.name,
      firstVisitDate: visitDate,
      lastTreatment: patient.lastTreatment ?? "No treatment",
      currentAppointmentReason: patient.currentAppointmentReason,
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

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfoSection(mockPatient, daysSinceFirstVisit),
            SizedBox(height: 16),
            _buildDentalChartSection(mockPatient.dentalChart!),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection(Patient patient, int daysSinceFirstVisit) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow('First Visit:',
                      '${patient.firstVisitDate.toLocal()}'.split(' ')[0]),
                  _buildInfoRow('Last Treatment:',
                      patient.lastTreatment ?? "No treatment"),
                  _buildInfoRow(
                      'Current Appointment:', patient.currentAppointmentReason),
                  _buildInfoRow(
                      'Days Since First Visit:', '$daysSinceFirstVisit days'),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/user_profile_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dental Chart',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
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
