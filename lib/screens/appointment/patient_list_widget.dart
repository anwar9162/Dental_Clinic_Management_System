import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/patient_model.dart';
import '../patient/patient_bloc/patient_bloc.dart';
import '../patient/patient_bloc/patient_event.dart';
import '../patient/patient_bloc/patient_state.dart';

class PatientListWidget extends StatelessWidget {
  final void Function(Patient) onPatientSelected;

  PatientListWidget({required this.onPatientSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {
        if (state is PatientLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PatientError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is PatientLoaded) {
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
                  onChanged: (query) {
                    context
                        .read<PatientBloc>()
                        .add(LoadPatients()); // Re-fetch patients on search
                  },
                  decoration: InputDecoration(
                    labelText: "Search Patients",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: state.patients.map((patient) {
                      final patientModel = Patient.fromJson(
                          patient); // Convert map to Patient model
                      return ListTile(
                        title: Text(
                          '${patientModel.firstName} ${patientModel.lastName}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          onPatientSelected(patientModel);
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
}
