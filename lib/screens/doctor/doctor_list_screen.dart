import 'package:flutter/material.dart';
import 'add_doctor_screen.dart';
import 'doctor_detail_screen.dart';
import '../../widgets/navigation_drawer.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final List<Map<String, String>> _doctors = [
    {'name': 'Dr. John Smith', 'specialty': 'Orthodontist'},
    {'name': 'Dr. Jane Doe', 'specialty': 'Periodontist'},
  ];

  Map<String, String>? _selectedDoctor;
  bool _isAddingDoctor = false;

  void _selectDoctor(Map<String, String> doctor) {
    setState(() {
      _selectedDoctor = doctor;
      _isAddingDoctor = false;
    });
  }

  void _showAddDoctorScreen() {
    setState(() {
      _isAddingDoctor = true;
      _selectedDoctor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors List'),
        centerTitle: true,
      ),
      drawer: CustomNavigationDrawer(),
      body: Row(
        children: [
          // Narrowed doctor list
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                final isSelected = _selectedDoctor == doctor;
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  elevation: isSelected ? 6 : 2,
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  child: ListTile(
                    title: Text(
                      doctor['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    subtitle:
                        Text(doctor['specialty']!, textAlign: TextAlign.center),
                    onTap: () => _selectDoctor(doctor),
                  ),
                );
              },
            ),
          ),
          // Expanded details area
          Expanded(
            flex: 2,
            child: _isAddingDoctor
                ? AddDoctorScreen()
                : _selectedDoctor == null
                    ? const Center(
                        child: Text('Select a doctor to see details'))
                    : DoctorDetailScreen(
                        name: _selectedDoctor!['name']!,
                        specialty: _selectedDoctor!['specialty']!,
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDoctorScreen,
        tooltip: 'Add Doctor',
        child: const Icon(Icons.add),
      ),
    );
  }
}
