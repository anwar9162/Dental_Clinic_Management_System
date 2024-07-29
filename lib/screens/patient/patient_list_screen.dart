import 'package:flutter/material.dart';
import '../patient/PatientDetailWidget.dart';
import '../../models/patient_model.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Patient> _patients =
      mockPatients; // Using mockPatient from patient_model.dart
  String _searchQuery = '';
  Patient? selectedPatient;

  List<Patient> get _filteredPatients {
    return _searchQuery.isEmpty
        ? _patients
        : _patients
            .where((patient) =>
                patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      selectedPatient = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List', style: TextStyle(fontSize: 20)),
        elevation: 4,
        backgroundColor: Colors.teal,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _onSearch,
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Total Patients: ${_filteredPatients.length}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];
                        final isSelected = selectedPatient == patient;
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.teal[50] : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              patient.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              'Last Treatment: ${patient.lastTreatment}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            leading: Icon(
                              Icons.person,
                              color: Colors.teal,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.teal),
                            onTap: () {
                              setState(() {
                                selectedPatient = patient;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: selectedPatient == null
                ? Center(
                    child: Text(
                      'Select a patient to view details',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  )
                : PatientDetailWidget(patient: selectedPatient!),
          ),
        ],
      ),
    );
  }
}
