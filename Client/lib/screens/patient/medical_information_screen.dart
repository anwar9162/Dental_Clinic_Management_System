import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../patient/PatientDetailWidget.dart';
import '../../../models/basic_patient_info_model.dart';
import 'patient_bloc/medical_information_bloc.dart';
import 'patient_bloc/medical_information_event.dart';
import 'patient_bloc/medical_information_state.dart';
import '../../services/patient_api_service.dart';

class MedicalInformationScreen extends StatefulWidget {
  @override
  _MedicalInformationScreenState createState() =>
      _MedicalInformationScreenState();
}

class _MedicalInformationScreenState extends State<MedicalInformationScreen> {
  late final MedicalInformationBloc _bloc;
  String _searchQuery = '';
  PatientBasicInfo? selectedPatient;

  List<PatientBasicInfo> get _filteredPatients {
    final state = _bloc.state;
    if (state is MedicalInformationBasicInfoLoaded) {
      return _searchQuery.isEmpty
          ? state.basicPatientInfo
          : state.basicPatientInfo
              .where((patient) => patient.firstName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
    }
    return [];
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      selectedPatient = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _bloc = MedicalInformationBloc(PatientApiService());
    _bloc.add(FetchBasicPatientInfo()); // Fetch basic patient info
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          _bloc, // Ensure that the BlocProvider is available in the context
      child: Scaffold(
        appBar: AppBar(
          title: Text('Patients List', style: TextStyle(fontSize: 20)),
          elevation: 4,
          backgroundColor: Color(0xFF6ABEDC),
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
        body: BlocBuilder<MedicalInformationBloc, MedicalInformationState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is MedicalInformationLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MedicalInformationBasicInfoLoaded) {
              return Row(
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
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
                                    color: isSelected
                                        ? Colors.teal[50]
                                        : Colors.white,
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
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    title: Text(
                                      '${patient.firstName} ${patient.lastName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      'Phone: ${patient.phoneNumber}',
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12),
                                    ),
                                    leading: Icon(
                                      Icons.person,
                                      color: Colors.teal,
                                      size: 24,
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.teal,
                                    ),
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
                    flex: 5,
                    child: selectedPatient == null
                        ? Center(
                            child: Text(
                              'Select a patient to view details',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          )
                        : PatientDetailWidget(
                            patientBasicInfo: selectedPatient!),
                  ),
                ],
              );
            } else if (state is MedicalInformationError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
