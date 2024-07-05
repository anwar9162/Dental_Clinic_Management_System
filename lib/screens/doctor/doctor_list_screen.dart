import 'package:flutter/material.dart';
import 'add_doctor_screen.dart';
import 'doctor_detail_screen.dart';
import '../../models/doctor_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class DoctorListScreen extends StatelessWidget {
  final List<Map<String, String>> doctors = [
    {'name': 'Dr. John Smith', 'specialty': 'Orthodontist'},
    {'name': 'Dr. Jane Doe', 'specialty': 'Periodontist'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      drawer: custom.NavigationDrawer(),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(doctor['name']!),
              subtitle: Text(doctor['specialty']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailScreen(
                      name: doctor['name']!,
                      specialty: doctor['specialty']!,
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
            MaterialPageRoute(builder: (context) => AddDoctorScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
