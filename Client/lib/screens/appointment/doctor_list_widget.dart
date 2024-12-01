import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../doctor/blocs/doctor_bloc.dart';
import '../doctor/blocs/doctor_event.dart';
import '../doctor/blocs/doctor_state.dart';

class DoctorListWidget extends StatefulWidget {
  final void Function(Map<String, dynamic>?) onDoctorSelected;

  DoctorListWidget({required this.onDoctorSelected});

  @override
  _DoctorListWidgetState createState() => _DoctorListWidgetState();
}

class _DoctorListWidgetState extends State<DoctorListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allDoctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  Map<String, dynamic>? _selectedDoctor;

  @override
  void initState() {
    super.initState();
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

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredDoctors = _allDoctors;
      _selectedDoctor = null;
    });
    widget.onDoctorSelected(null); // Notify about unselection
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
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
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is DoctorError) {
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
        } else if (state is DoctorsLoaded) {
          if (_allDoctors.isEmpty) {
            _allDoctors = state.doctors;
            _filteredDoctors = _allDoctors;
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
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                  ),
                  onTap: () {
                    if (_selectedDoctor != null) {
                      _searchController.text = _selectedDoctor!['name'];
                      _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _searchController.text.length));
                    }
                  },
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView(
                    children: _filteredDoctors.isEmpty
                        ? [Center(child: Text('No doctors found'))]
                        : _filteredDoctors.map((doctor) {
                            final isSelected = doctor == _selectedDoctor;
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
                                doctor['name'],
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(doctor['specialty']),
                              onTap: () {
                                setState(() {
                                  _selectedDoctor = doctor;
                                  _searchController.text =
                                      _selectedDoctor!['name'];
                                });
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
            child: Center(child: Text('No data available')),
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
