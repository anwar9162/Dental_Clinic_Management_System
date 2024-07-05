import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class DoctorDetailScreen extends StatelessWidget {
  final String name;
  final String specialty;

  DoctorDetailScreen({required this.name, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
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
              'Specialty: $specialty',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
