import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/patient_model.dart';
import '../patient/patient_bloc/patient_bloc.dart';
import '../patient/patient_bloc/patient_event.dart';
import '../patient/patient_bloc/patient_state.dart';

class PatientListWidget extends StatefulWidget {
  final void Function(Patient) onPatientSelected;

  PatientListWidget({required this.onPatientSelected});

  @override
  _PatientListWidgetState createState() => _PatientListWidgetState();
}

class _PatientListWidgetState extends State<PatientListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    // Fetch all patients initially
    context.read<PatientBloc>().add(LoadPatients());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        final fullName =
            '${patient.firstName} ${patient.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PatientError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is PatientLoaded) {
          // Store all patients only when they are loaded
          if (_allPatients.isEmpty) {
            _allPatients = state.patients.map((patient) {
              return Patient.fromJson(patient);
            }).toList();
            _filteredPatients = _allPatients; // Initialize filtered list
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
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: _filteredPatients.isEmpty
                        ? [Center(child: Text('No patients found'))]
                        : _filteredPatients.map((patient) {
                            return ListTile(
                              title: Text(
                                '${patient.firstName} ${patient.lastName}',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                              onTap: () {
                                widget.onPatientSelected(patient);
                              },
                            );
                          }).toList(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No patients available'));
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
