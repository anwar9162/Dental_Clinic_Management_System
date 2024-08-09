import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart';
import '../../utils/constants.dart'; // Import the constants file

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'Kibrom Adinew',
      date: DateTime.now(),
      firstVisitDate: DateTime(2024, 6, 25),
      lastTreatment: 'Brace',
      currentAppointmentReason: 'Emergency Consultation',
      doctorName: 'Dr. Smith',
    ),
    Appointment(
      id: '2',
      patientName: 'Matebe Assfaw',
      date: DateTime.now(),
      doctorName: 'Dr. Johnson',
      firstVisitDate: DateTime(2024, 6, 25),
      lastTreatment: 'Brace',
      currentAppointmentReason: 'Emergency Consultation',
    ),
  ];

  final List<Patient> _walkInPatients = [
    Patient(
      firstName: "Kibrom",
      lastName: "Adinew",
      phoneNumber: "0712345678",
      firstVisitDate: DateTime(2024, 6, 25),
    ),
  ];

  final List<Patient> _newPatients = [
    Patient(
      firstName: "Kibrom",
      lastName: "Adinew",
      phoneNumber: "0712345678",
      firstVisitDate: DateTime(2024, 6, 25),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Color(0xFF6ABEDC),
      ),
      body: Container(
        color: backgroundColor, // Ensure background color is set correctly
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoCard(
                      context,
                      title: 'Today\'s Appointment',
                      count: _appointments.length,
                      icon: Icons.person,
                      color: Colors.red,
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Walk-In Patients',
                      count: _walkInPatients.length,
                      icon: Icons.person_outline,
                      color: Colors.orange,
                    ),
                    _buildInfoCard(
                      context,
                      title: 'New Patients',
                      count: _newPatients.length,
                      icon: Icons.person_add,
                      color: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                StaggeredGrid.count(
                  crossAxisCount: 3, // Change to 3 columns
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildDetailCard(
                      context,
                      title: 'Today\'s Appointment',
                      appointments: _appointments,
                    ),
                    _buildDetailCard(
                      context,
                      title: 'Today\'s Walk-In Patients',
                      patients: _walkInPatients,
                    ),
                    _buildDetailCard(
                      context,
                      title: 'Today\'s New Patients',
                      patients: _newPatients,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      elevation: 6,
      shape: CircleBorder(
          // borderRadius: BorderRadius.circular(15),
          ),
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context,
      {required String title,
      List<Appointment>? appointments,
      List<Patient>? patients}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 252, 252, 252),
              Color.fromARGB(255, 198, 243, 211),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount:
                      (appointments?.length ?? 0) + (patients?.length ?? 0),
                  itemBuilder: (context, index) {
                    if (index < (appointments?.length ?? 0)) {
                      final appointment = appointments![index];
                      return _buildListTile(
                        appointment.patientName,
                        'Last Treatment: ${appointment.lastTreatment}',
                        'Current Appointment: ${appointment.currentAppointmentReason}',
                        'Days Since First Visit: ${_daysSinceFirstVisit(appointment.firstVisitDate)}',
                      );
                    } else {
                      final patient =
                          patients![index - (appointments?.length ?? 0)];
                      return _buildListTile(
                        patient.firstName ?? 'Unknown',
                        'Days Since First Visit: ${_daysSinceFirstVisit(patient.firstVisitDate)}',
                        '', // Add placeholders for empty subtitles
                        '',
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      String title, String subtitle1, String subtitle2, String subtitle3) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.teal),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle1),
            Text(subtitle2),
            Text(subtitle3),
          ],
        ),
      ),
    );
  }

  int _daysSinceFirstVisit(DateTime? firstVisitDate) {
    if (firstVisitDate == null) {
      return 0;
    }
    return DateTime.now().difference(firstVisitDate).inDays;
  }
}
