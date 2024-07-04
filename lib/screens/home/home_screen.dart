import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class HomeScreen extends StatelessWidget {
  final List<Appointment> _appointments = [
    Appointment(
        id: '1',
        patientName: 'John Doe',
        date: DateTime.now(),
        description: 'Routine Checkup',
        doctorName: 'Dr. Smith'),
    Appointment(
        id: '2',
        patientName: 'Jane Doe',
        date: DateTime.now(),
        description: 'Tooth Extraction',
        doctorName: 'Dr. Johnson'),
  ];

  final List<Patient> _walkInPatients = [
    Patient(id: '5', name: 'Michael Jordan'),
  ];

  final List<Patient> _newPatients = [
    Patient(id: '6', name: 'LeBron James'),
  ];

  int _expectedPatientsCount() {
    DateTime today = DateTime.now();
    return _appointments
        .where((appointment) =>
            appointment.date.year == today.year &&
            appointment.date.month == today.month &&
            appointment.date.day == today.day)
        .length;
  }

  int _walkInPatientsCount() {
    return _walkInPatients.length;
  }

  int _newPatientsCount() {
    return _newPatients.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dental Clinic Management - Home'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard(
                  context,
                  title: 'Expected Patients',
                  count: _expectedPatientsCount(),
                  icon: Icons.person,
                  color: Colors.teal,
                ),
                _buildInfoCard(
                  context,
                  title: 'Walk-In Patients',
                  count: _walkInPatientsCount(),
                  icon: Icons.person_outline,
                  color: Colors.orange,
                ),
                _buildInfoCard(
                  context,
                  title: 'New Patients',
                  count: _newPatientsCount(),
                  icon: Icons.person_add,
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailCard(
                    context,
                    title: 'Today\'s Expected Patients',
                    patients: _appointments.map((a) => a.patientName).toList(),
                  ),
                  _buildDetailCard(
                    context,
                    title: 'Today\'s Walk-In Patients',
                    patients: _walkInPatients.map((p) => p.name).toList(),
                  ),
                  _buildDetailCard(
                    context,
                    title: 'Today\'s New Patients',
                    patients: _newPatients.map((p) => p.name).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title,
      required int count,
      required IconData icon,
      required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: color,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        height: 150,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context,
      {required String title, required List<String> patients}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ...patients.map((patient) => ListTile(
                  leading: Icon(Icons.person),
                  title: Text(patient),
                )),
          ],
        ),
      ),
    );
  }
}
