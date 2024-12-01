import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/patient_model.dart';
import '../patient/patient_bloc/patient_bloc.dart';
import '../patient/patient_bloc/patient_event.dart';
import '../patient/patient_bloc/patient_state.dart';

class PatientListWidget extends StatefulWidget {
  final void Function(Patient?) onPatientSelected;

  PatientListWidget({required this.onPatientSelected});

  @override
  _PatientListWidgetState createState() => _PatientListWidgetState();
}

class _PatientListWidgetState extends State<PatientListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  Patient? _selectedPatient;

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        final fullName =
            '${patient.firstName} ${patient.lastName}'.toLowerCase();
        final phone = patient.phoneNumber?.toLowerCase() ?? '';
        return fullName.contains(query) || phone.contains(query);
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredPatients = _allPatients;
      _selectedPatient = null;
    });
    widget.onPatientSelected(null); // Notify about unselection
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Center(child: Text('Loading...')),
          );
        } else if (state is PatientError) {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Center(child: Text('Error: ${state.message}')),
          );
        } else if (state is PatientLoaded) {
          if (_allPatients.isEmpty) {
            _allPatients = state.patients
                .map((patientMap) => Patient.fromJson(patientMap))
                .toList();
            _filteredPatients = _allPatients;
          }

          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Search Patients",
                    border: OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                  ),
                  onTap: () {
                    if (_selectedPatient != null) {
                      _searchController.text =
                          '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}';
                      _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _searchController.text.length));
                    }
                  },
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: _filteredPatients.isEmpty
                        ? [Center(child: Text('No patients found'))]
                        : _filteredPatients.map((patient) {
                            final isSelected = patient == _selectedPatient;
                            return ListTile(
                              leading: isSelected
                                  ? Container(
                                      width: 5.0,
                                      color: Colors.blue,
                                    )
                                  : null,
                              tileColor: isSelected
                                  ? Colors.blue.shade100
                                  : Colors.transparent,
                              title: Text(
                                '${patient.firstName} ${patient.lastName}',
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: patient.phoneNumber != null
                                  ? Text('Phone: ${patient.phoneNumber}')
                                  : null,
                              onTap: () {
                                setState(() {
                                  if (_selectedPatient == patient) {
                                    _selectedPatient =
                                        null; // Deselect if already selected
                                  } else {
                                    _selectedPatient =
                                        patient; // Select new patient
                                  }
                                  _searchController.text = _selectedPatient !=
                                          null
                                      ? '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}'
                                      : '';
                                });
                                widget.onPatientSelected(_selectedPatient);
                              },
                            );
                          }).toList(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Center(child: Text('No patients available')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
