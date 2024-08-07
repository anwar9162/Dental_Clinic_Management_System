import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_doctor_screen.dart';
import 'doctor_detail_screen.dart';
import 'blocs/doctor_bloc.dart';
import 'blocs/doctor_event.dart';
import 'blocs/doctor_state.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(FetchAllDoctors());
  }

  void _selectDoctor(String id) {
    context.read<DoctorBloc>().add(FetchDoctorById(id));
  }

  void _showAddDoctorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDoctorScreen()),
    ).then((_) => context.read<DoctorBloc>().add(FetchAllDoctors()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors List'),
        backgroundColor: Color(0xFF6ABEDC),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DoctorsLoaded) {
                  return ListView.builder(
                    itemCount: state.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = state.doctors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        elevation: 2,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            doctor['name']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            doctor['specialty']!,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () => _selectDoctor(
                              doctor['_id']!), // Assuming '_id' is the ID field
                        ),
                      );
                    },
                  );
                } else if (state is DoctorError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('No doctors available.'));
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DoctorLoaded) {
                  final doctor = state.doctor;
                  return DoctorDetailScreen(
                    name: doctor['name']!,
                    specialty: doctor['specialty']!,
                    gender: doctor['gender']!,
                    phone: doctor['phone']!,
                  );
                } else {
                  return const Center(
                      child: Text('Select a doctor to see details'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDoctorScreen,
        tooltip: 'Add Doctor',
        child: const Icon(Icons.add),
      ),
    );
  }
}
