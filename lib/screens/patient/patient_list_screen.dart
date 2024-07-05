import 'package:flutter/material.dart';
import '../patient/add_patient_screen.dart';
import '../patient/patient_detail_screen.dart';
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class PatientListScreen extends StatelessWidget {
  final List<Patient> patients = [
    Patient(
      id: '1',
      name: 'John Doe',
      firstVisitDate: DateTime.now().subtract(Duration(days: 365)),
      lastTreatment: 'Root Canal',
      currentAppointmentReason: 'Routine Checkup',
    ),
    Patient(
      id: '2',
      name: 'Jane Doe',
      firstVisitDate: DateTime.now().subtract(Duration(days: 200)),
      lastTreatment: 'Tooth Extraction',
      currentAppointmentReason: 'Toothache',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      drawer: custom.NavigationDrawer(),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(patient.name),
              subtitle: Text('Last Treatment: ${patient.lastTreatment}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailScreen(
                      name: patient.name,
                      firstVisitDate: patient.firstVisitDate,
                      lastTreatment: patient.lastTreatment,
                      currentAppointmentReason:
                          patient.currentAppointmentReason,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
