import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../models/appointment_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class PatientRecordScreen extends StatelessWidget {
  final Patient patient;

  PatientRecordScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Record: ${patient.name}'),
      ),
      drawer: custom.NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Personal Information'),
              _buildPersonalInfoCard(patient),
              SizedBox(height: 20),
              _buildSectionTitle('Medical History'),
              _buildMedicalHistoryCard(patient),
              SizedBox(height: 20),
              _buildSectionTitle('Appointment History'),
              _buildAppointmentHistoryCard(patient),
              SizedBox(height: 20),
              _buildSectionTitle('Treatment Plan'),
              _buildTreatmentPlanCard(patient),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPersonalInfoCard(Patient patient) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', patient.name),
            _buildInfoRow('Date of Birth', '1990-01-01'), // Mock data
            _buildInfoRow('Gender', 'Male'), // Mock data
            _buildInfoRow('Phone Number', '123-456-7890'), // Mock data
            _buildInfoRow('Email', 'johndoe@example.com'), // Mock data
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryCard(Patient patient) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('First Visit Date',
                patient.firstVisitDate.toString().split(' ')[0]),
            _buildInfoRow('Last Treatment', patient.lastTreatment ?? 'N/A'),
            _buildInfoRow('Known Allergies', 'None'), // Mock data
            _buildInfoRow('Chronic Conditions', 'None'), // Mock data
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentHistoryCard(Patient patient) {
    // Mock appointments
    List<Appointment> appointments = [
      Appointment(
          id: '1',
          patientName: patient.name,
          date: DateTime.now().subtract(Duration(days: 30)),
          description: 'Routine Checkup',
          doctorName: 'Dr. Smith'),
      Appointment(
          id: '2',
          patientName: patient.name,
          date: DateTime.now().subtract(Duration(days: 60)),
          description: 'Tooth Extraction',
          doctorName: 'Dr. Johnson'),
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: appointments.map((appointment) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                appointment.description,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'Date: ${appointment.date.toString().split(' ')[0]}\nDoctor: ${appointment.doctorName}'),
              isThreeLine: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTreatmentPlanCard(Patient patient) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                'Current Appointment Reason', patient.currentAppointmentReason),
            _buildInfoRow('Next Appointment Date', '2023-10-01'), // Mock data
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
