import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart' as custom;

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
    //int daysSinceFirstVisit = DateTime.now().difference(firstVisitDate).inDays;
    int daysSinceFirstVisit = DateTime.now().difference(visitDate).inDays;
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'First Visit Date: ${visitDate.toLocal()}'.split(' ')[0],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Last Treatment: $lastTreatment',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Current Appointment Reason: $currentAppointmentReason',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Days Since First Visit: $daysSinceFirstVisit',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
