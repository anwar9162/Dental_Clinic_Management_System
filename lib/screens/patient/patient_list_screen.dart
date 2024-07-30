import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'add_patient_screen.dart';
import 'add_arrived_patient_screen.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Map<String, String>> patients = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'phoneNumber': '1234567890',
      'gender': 'Male',
      'dob': '01/01/1990',
      'address': '123 Main St'
    },
    {
      'firstName': 'Jane',
      'lastName': 'Smith',
      'phoneNumber': '0987654321',
      'gender': 'Female',
      'dob': '02/02/1995',
      'address': '456 Elm St'
    },
    // Add more mock patients as needed
  ];

  String _searchQuery = '';

  List<Map<String, String>> get _filteredPatients {
    if (_searchQuery.isEmpty) return patients;
    return patients.where((patient) {
      return patient.values.any(
          (value) => value.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  void _editPatient(int index) {
    // Implement your edit patient logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Edit details for ${patients[index]['firstName']} ${patients[index]['lastName']}'),
              // Add your editing form here
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Save logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePatient(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Patient'),
          content: Text('Are you sure you want to delete this patient?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  patients.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _openAddPatientScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddPatientScreen(
            onClose: () {
              Navigator.of(context).pop();
              // Optionally, refresh the patient list here if needed
            },
          );
        },
      ),
    );
  }

  void _openAddArrivedPatientScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddArrivedPatientScreen(
            onClose: () {
              Navigator.of(context).pop();
              // Optionally, refresh the patient list here if needed
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Management'),
        backgroundColor: Color(0xFF6ABEDC),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Patients',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable2(
                  columnSpacing: 16,
                  horizontalMargin: 12,
                  minWidth: 800,
                  headingRowColor: MaterialStateProperty.all(
                      Color(0xFF6ABEDC)), // Use specified color for header
                  dataRowColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.white;
                    },
                  ),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  dataTextStyle: TextStyle(color: Colors.black87),
                  columns: [
                    DataColumn(label: Text('No.')),
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Gender')),
                    DataColumn(label: Text('Date of Birth')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _filteredPatients.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> patient = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(patient['firstName'] ?? '')),
                        DataCell(Text(patient['lastName'] ?? '')),
                        DataCell(Text(patient['phoneNumber'] ?? '')),
                        DataCell(Text(patient['gender'] ?? '')),
                        DataCell(Text(patient['dob'] ?? '')),
                        DataCell(Text(patient['address'] ?? '')),
                        DataCell(Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xFF00796B)),
                              onPressed: () => _editPatient(index),
                              tooltip: 'Edit Patient',
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xFFD32F2F)),
                              onPressed: () => _deletePatient(index),
                              tooltip: 'Delete Patient',
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text('Add New Patient'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00796B), // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: _openAddPatientScreen,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.check_circle_outline),
                  label: Text('Mark Arrived Patient'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD32F2F), // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: _openAddArrivedPatientScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
