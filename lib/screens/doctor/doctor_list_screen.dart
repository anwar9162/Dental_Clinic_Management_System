import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'add_doctor_screen.dart';
import 'doctor_detail_screen.dart';
import 'blocs/doctor_bloc.dart';
import 'blocs/doctor_event.dart';
import 'blocs/doctor_state.dart';
import 'blocs/doctor_detail_bloc.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  bool _showingAddDoctorScreen = false;
  String? _selectedDoctorId;

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(FetchAllDoctors());
  }

  void _selectDoctor(String id) {
    setState(() {
      _showingAddDoctorScreen = false;
      _selectedDoctorId = id;
    });
    context.read<DoctorDetailBloc>().add(FetchDoctorById(id));
  }

  void _showAddDoctorScreen() {
    setState(() {
      _showingAddDoctorScreen = true;
      _selectedDoctorId = null;
    });
  }

  void _editDoctor(String id) {
    setState(() {
      _showingAddDoctorScreen = true;
      _selectedDoctorId = id;
    });
  }

  void _deleteDoctor(String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Delete Doctor'),
        content: Text('Are you sure you want to delete this doctor?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              minimumSize: Size(80, 36),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<DoctorBloc>().add(DeleteDoctor(id));
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF6ABEDC),
              minimumSize: Size(80, 36),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors List'),
        backgroundColor: Color(0xFF6ABEDC),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorLoading) {
            return Center(
              child: SpinKitFadingCircle(
                color: Color(0xFF6ABEDC),
                size: 40.0, // Reduced size
              ),
            );
          } else if (state is DoctorsLoaded) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: state.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8), // Reduced padding
                          leading: CircleAvatar(
                            radius: 24, // Smaller avatar
                            backgroundColor: Color(0xFF6ABEDC),
                            child: Text(
                              doctor['name']![0],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16, // Smaller font size
                              ),
                            ),
                          ),
                          title: Text(
                            doctor['name']!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text(
                            doctor['specialty']!,
                            style: TextStyle(fontSize: 12),
                          ),
                          onTap: () => _selectDoctor(doctor['_id']!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.orange,
                                onPressed: () => _editDoctor(doctor['_id']!),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _deleteDoctor(doctor['_id']!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _showingAddDoctorScreen
                      ? AddDoctorScreen()
                      : BlocBuilder<DoctorDetailBloc, DoctorState>(
                          builder: (context, state) {
                            if (state is DoctorDetailLoading) {
                              return Center(
                                child: SpinKitFadingCircle(
                                  color: Color(0xFF6ABEDC),
                                  size: 40.0, // Reduced size
                                ),
                              );
                            } else if (state is DoctorDetailLoaded) {
                              final doctor = state.doctor;
                              return DoctorDetailScreen(
                                name: doctor['name']!,
                                specialty: doctor['specialty']!,
                                gender: doctor['gender']!,
                                phone: doctor['phone']!,
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'Select a doctor to see details',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                          },
                        ),
                ),
              ],
            );
          } else if (state is DoctorError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Center(
              child: Text(
                'No doctors available.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDoctorScreen,
        tooltip: 'Add Doctor',
        backgroundColor: Color(0xFF6ABEDC),
        child: const Icon(Icons.add, size: 28), // Slightly smaller icon
      ),
    );
  }
}
