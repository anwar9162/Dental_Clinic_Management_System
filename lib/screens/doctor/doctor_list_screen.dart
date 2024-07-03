import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class DoctorListScreen extends StatelessWidget {
  final List<Map<String, String>> mockDoctors = [
    {'name': 'Dr. John Adams', 'specialty': 'Orthodontist'},
    {'name': 'Dr. Emily Clarke', 'specialty': 'Periodontist'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      drawer: custom.NavigationDrawer(),
      body: ListView.builder(
        itemCount: mockDoctors.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mockDoctors[index]['name']!),
            subtitle: Text(mockDoctors[index]['specialty']!),
          );
        },
      ),
    );
  }
}
