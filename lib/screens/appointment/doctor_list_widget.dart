import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../doctor/blocs/doctor_bloc.dart';
import '../doctor/blocs/doctor_event.dart';
import '../doctor/blocs/doctor_state.dart';

class DoctorListWidget extends StatefulWidget {
  final void Function(Map<String, dynamic>) onDoctorSelected;

  DoctorListWidget({required this.onDoctorSelected});

  @override
  _DoctorListWidgetState createState() => _DoctorListWidgetState();
}

class _DoctorListWidgetState extends State<DoctorListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    // Initial fetch of doctors
    context.read<DoctorBloc>().add(FetchAllDoctors());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _allDoctors.where((doctor) {
        final name = doctor['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DoctorError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DoctorsLoaded) {
          // Store all doctors only when they are loaded
          if (_allDoctors.isEmpty) {
            _allDoctors = state.doctors;
            _filteredDoctors = _allDoctors; // Initialize filtered list
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
                    labelText: "Search Doctors",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: _filteredDoctors.isEmpty
                        ? [Center(child: Text('No doctors found'))]
                        : _filteredDoctors.map((doctor) {
                            return ListTile(
                              title: Text(doctor['name']),
                              subtitle: Text(doctor['specialty']),
                              onTap: () {
                                widget.onDoctorSelected(doctor);
                              },
                            );
                          }).toList(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
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
