import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'add_patient_screen.dart';
import 'add_arrived_patient_screen.dart';
import 'payment_data_screen.dart';
import 'patient_bloc/patient_bloc.dart';
import 'patient_bloc/patient_event.dart';
import 'patient_bloc/patient_state.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  bool _showAddPatientScreen = false;
  bool _showAddArrivedPatientScreen = false;
  bool _showPaymentDataScreen = false;
  String _searchQuery = '';
  List<Map<String, dynamic>> _patients = []; // Store patient data

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients()); // Load patients on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Management'),
        backgroundColor: Color(0xFF6ABEDC),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildSearchField(),
                Expanded(
                  child: BlocBuilder<PatientBloc, PatientState>(
                    builder: (context, state) {
                      if (state is PatientLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is PatientLoaded) {
                        _patients = state.patients; // Update the patients data
                        final filteredPatients = _patients.where((patient) {
                          return patient.values.any((value) => value
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()));
                        }).toList();
                        if (filteredPatients.isEmpty) {
                          return Center(child: Text('No patients found.'));
                        } else {
                          return _buildPatientTable(filteredPatients);
                        }
                      } else if (state is PatientError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return Center(child: Text('No data available'));
                    },
                  ),
                ),
                _buildActionButtons(),
              ],
            ),
          ),
          if (_showAddPatientScreen ||
              _showAddArrivedPatientScreen ||
              _showPaymentDataScreen)
            Container(
              width: 600,
              child: _showAddPatientScreen
                  ? AddPatientScreen(onClose: _toggleAddPatientScreen)
                  : _showAddArrivedPatientScreen
                      ? AddArrivedPatientScreen(
                          onClose: _toggleAddArrivedPatientScreen,
                          patients: _patients,
                        )
                      : PaymentDataScreen(
                          onClose: _togglePaymentDataScreen,
                          patients: _patients,
                        ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
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
    );
  }

  Widget _buildPatientTable(List<Map<String, dynamic>> patients) {
    // Reverse the list to show latest entries first
    List<Map<String, dynamic>> reversedPatients = patients.reversed.toList();

    return Card(
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
          headingRowColor: MaterialStateProperty.all(Color(0xFF6ABEDC)),
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
          rows: reversedPatients.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> patient = entry.value;

            // Format date of birth
            String formattedDateOfBirth = '';
            if (patient['dateOfBirth'] != null) {
              DateTime dob = DateTime.parse(patient['dateOfBirth']);
              formattedDateOfBirth = DateFormat('yyyy-MM-dd').format(dob);
            }

            return DataRow(
              cells: [
                DataCell(Text((index + 1).toString())),
                DataCell(Text(patient['firstName'] ?? '')),
                DataCell(Text(patient['lastName'] ?? '')),
                DataCell(Text(patient['phoneNumber'] ?? '')),
                DataCell(Text(patient['Gender'] ?? '')),
                DataCell(Text(formattedDateOfBirth)), // Display formatted date
                DataCell(Text(patient['Address'] ?? '')),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF00796B)),
                      onPressed: () => _editPatient(patient['_id']),
                      tooltip: 'Edit Patient',
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete, color: Color(0xFFD32F2F)),
                      onPressed: () => _deletePatient(patient['_id']),
                      tooltip: 'Delete Patient',
                    ),
                  ],
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.person_add),
            label: Text('Add New Patient'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00796B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            onPressed: _toggleAddPatientScreen,
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.check_circle_outline),
            label: Text('Mark Arrived Patient'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            onPressed: _toggleAddArrivedPatientScreen,
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.payment),
            label: Text('Payment Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00796B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
            onPressed: _togglePaymentDataScreen,
          ),
        ],
      ),
    );
  }

  void _editPatient(String id) {
    // Implement edit functionality
  }

  void _deletePatient(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Patient'),
          content: Text('Are you sure you want to delete this patient?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.read<PatientBloc>().add(DeletePatient(id));
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _toggleAddPatientScreen() {
    setState(() {
      _showAddPatientScreen = !_showAddPatientScreen;
      _showAddArrivedPatientScreen = false;
      _showPaymentDataScreen = false;
    });
  }

  void _toggleAddArrivedPatientScreen() {
    setState(() {
      _showAddArrivedPatientScreen = !_showAddArrivedPatientScreen;
      _showAddPatientScreen = false;
      _showPaymentDataScreen = false;
    });
  }

  void _togglePaymentDataScreen() {
    setState(() {
      _showPaymentDataScreen = !_showPaymentDataScreen;
      _showAddPatientScreen = false;
      _showAddArrivedPatientScreen = false;
    });
  }
}
