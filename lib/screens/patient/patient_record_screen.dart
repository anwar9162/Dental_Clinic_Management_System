import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../models/appointment_model.dart';

class PatientRecordScreen extends StatelessWidget {
  final Patient patient;

  PatientRecordScreen({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Teal background color
        title: Text('Patient Record: ${patient.firstName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Information'),
            _buildPersonalInfoCard(
                context, patient), // Pass context to _buildPersonalInfoCard
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[900],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, Patient patient) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenProfileImage(
                imageAsset: 'assets/images/user_profile_image.jpg'),
          ),
        );
      },
      child: Hero(
        tag:
            'profileImage-${patient.firstName!}', // Unique tag for Hero animation
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/user_profile_image.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                _buildInfoRow('Name', patient.firstName!,
                    valueStyle: TextStyle(fontWeight: FontWeight.bold)),
                _buildInfoRow('Date of Birth', '1990-01-01'), // Mock data
                _buildInfoRow('Gender', 'Male'), // Mock data
                _buildInfoRow('Phone Number', '123-456-7890'), // Mock data
                _buildInfoRow('Email', 'johndoe@example.com'), // Mock data
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalHistoryCard(Patient patient) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('First Visit Date',
                patient.firstVisitDate.toString().split(' ')[0]),
            _buildInfoRow('Phone Number', patient.phoneNumber ?? 'N/A'),
            _buildInfoRow(
              'Known Allergies',
              'None',
              valueStyle: TextStyle(color: Colors.blueGrey[900]),
            ),
            _buildInfoRow(
              'Chronic Conditions',
              'None',
              valueStyle: TextStyle(color: Colors.blueGrey[900]),
            ),
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
          patientName: patient.firstName!,
          date: DateTime.now().subtract(Duration(days: 30)),
          description: 'Routine Checkup',
          doctorName: 'Dr. Smith'),
      Appointment(
          id: '2',
          patientName: patient.firstName!,
          date: DateTime.now().subtract(Duration(days: 60)),
          description: 'Tooth Extraction',
          doctorName: 'Dr. Johnson'),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: appointments.map((appointment) {
          return ListTile(
            title: Text(
              appointment.description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            subtitle: Text(
              'Date: ${appointment.date.toString().split(' ')[0]}\nDoctor: ${appointment.doctorName}',
              style: TextStyle(color: Colors.blueGrey[700]),
            ),
            isThreeLine: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTreatmentPlanCard(Patient patient) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'lastname',
              patient.lastName!,
              valueStyle: TextStyle(color: Colors.blueGrey[900]),
            ),
            _buildInfoRow(
              'Next Appointment Date',
              '2023-10-01', // Mock data
              valueStyle: TextStyle(color: Colors.blueGrey[900]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenProfileImage extends StatelessWidget {
  final String imageAsset;

  FullScreenProfileImage({required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Profile Image'),
      ),
      body: Center(
        child: Hero(
          tag:
              'profileImage-tag', // Make sure to use the same tag as in PatientRecordScreen
          child: Image.asset(imageAsset),
        ),
      ),
    );
  }
}
