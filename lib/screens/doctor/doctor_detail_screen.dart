import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String gender;
  final String phone;

  DoctorDetailScreen({
    required this.name,
    required this.specialty,
    required this.gender,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${name ?? 'N/A'}', // Handle potential null
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Specialty: ${specialty ?? 'N/A'}', // Handle potential null
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Phone: ${phone ?? 'N/A'}', // Handle potential null
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Gender: ${gender ?? 'N/A'}', // Handle potential null
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
