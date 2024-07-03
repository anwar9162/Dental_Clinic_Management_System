import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class PatientListScreen extends StatelessWidget {
  final List<Map<String, String>> mockPatients = [
    {'name': 'John Doe', 'id': '001', 'phone': '123-456-7890'},
    {'name': 'Jane Smith', 'id': '002', 'phone': '987-654-3210'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient List'),
      ),
      drawer: custom.NavigationDrawer(),
      body: ListView.builder(
        itemCount: mockPatients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mockPatients[index]['name']!),
            subtitle: Text('ID: ${mockPatients[index]['id']}'),
            trailing: Text(mockPatients[index]['phone']!),
          );
        },
      ),
    );
  }
}
