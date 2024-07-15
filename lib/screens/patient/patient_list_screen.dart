import 'package:flutter/material.dart';
import '../patient/PatientDetailWidget.dart'; // Import the widget
import '../patient/add_patient_screen.dart'; // Import the AddPatientScreen
import '../../models/patient_model.dart';
import '../../widgets/navigation_drawer.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final List<Patient> _patients = [
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
    // Add more patients as needed
  ];

  String _searchQuery = '';
  Patient? selectedPatient;
  bool _isAddingPatient = false;

  List<Patient> get _filteredPatients {
    if (_searchQuery.isEmpty) {
      return _patients;
    } else {
      return _patients.where((patient) {
        return patient.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleAddPatientScreen() {
    setState(() {
      _isAddingPatient = !_isAddingPatient;
      if (_isAddingPatient) {
        selectedPatient = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                  borderRadius: BorderRadius.circular(8),
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
      drawer: CustomNavigationDrawer(),
      body: Row(
        children: [
          // Patient List
          Expanded(
            flex: 1, // Reduced flex value for a narrower patient list
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
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            margin: EdgeInsets.all(0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              title: Text(patient.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              subtitle: Text(
                                'Last Treatment: ${patient.lastTreatment}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.teal, size: 20),
                              onTap: () {
                                setState(() {
                                  selectedPatient = patient;
                                  _isAddingPatient = false;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Patient Details or Add Patient Form
          Expanded(
            flex: 3, // Increased flex value for a wider patient detail or form
            child: _isAddingPatient
                ? AddPatientScreen(onClose: _toggleAddPatientScreen)
                : selectedPatient == null
                    ? Center(
                        child: Text('Select a patient to view details',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700])),
                      )
                    : PatientDetailWidget(patient: selectedPatient!),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAddPatientScreen,
        backgroundColor: Colors.teal,
        child: Icon(_isAddingPatient ? Icons.close : Icons.add),
      ),
    );
  }
}
