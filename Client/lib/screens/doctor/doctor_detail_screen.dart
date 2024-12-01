import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String gender;
  final String phone;
  final String address;
  final String username;

  DoctorDetailScreen({
    required this.name,
    required this.specialty,
    required this.gender,
    required this.phone,
    required this.address,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$name\'s Details'),
        backgroundColor: Color(0xFF6ABEDC),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'doctor-avatar',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFF6ABEDC),
                  child: Text(
                    name.isNotEmpty ? name[0] : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.person, 'Name', name),
                    _buildInfoRow(Icons.local_hospital, 'Specialty', specialty),
                    _buildInfoRow(Icons.phone, 'Phone', phone),
                    _buildInfoRow(Icons.transgender, 'Gender', gender),
                    _buildInfoRow(Icons.location_on, 'Address', address),
                    _buildInfoRow(Icons.account_circle, 'Username', username),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF6ABEDC), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
