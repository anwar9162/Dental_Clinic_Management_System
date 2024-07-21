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

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfoSection(patient, daysSinceFirstVisit),
            SizedBox(height: 16),
            _buildDentalChartSection(patient.dentalChart ?? []),
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
      color: const Color.fromARGB(
          244, 255, 255, 255), // Background color of the card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12), // Increased spacing between elements
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
            SizedBox(width: 20), // Increased spacing between sections
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[200], // Background color of the image container
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/user_profile_image.jpg',
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                color: Colors.grey[800],
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
      color: Colors.white, // Background color of the card
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
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12), // Increased spacing
            DentalChart(dentalChart: dentalChart),
          ],
        ),
      ),
    );
  }
}
