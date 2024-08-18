// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import 'models/arrival_model.dart'; // Import Arrival model
import '../../utils/constants.dart'; // Import the constants file
import 'info_card.dart';
import 'detail_card.dart';
import '../appointment/blocs/appointment_bloc.dart';
import '../appointment/blocs/appointment_event.dart';
import '../appointment/blocs/appointment_state.dart';
import '../patient/patient_bloc/patient_bloc.dart'; // Import the patient BLoC
import '../patient/patient_bloc/patient_state.dart';
import '../patient/patient_bloc/patient_event.dart';
import 'blocs/arrival_bloc.dart'; // Import the arrival BLoC
import 'blocs/arrival_event.dart';
import 'blocs/arrival_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Trigger events to load data
    BlocProvider.of<AppointmentBloc>(context).add(FetchTodaysAppointments());
    BlocProvider.of<PatientBloc>(context).add(LoadTodaysPatients());
    BlocProvider.of<ArrivalBloc>(context).add(LoadArrivalsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<ArrivalBloc, ArrivalState>(
              listener: (context, state) {
                if (state is ArrivalErrorState) {
                  // Log error message
                  print('Error loading arrivals: ${state.message}');
                }
              },
              child: BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, appointmentState) {
                  return BlocBuilder<PatientBloc, PatientState>(
                    builder: (context, patientState) {
                      return BlocBuilder<ArrivalBloc, ArrivalState>(
                        builder: (context, arrivalState) {
                          // Declare and initialize variables here
                          List<Patient> onAppointmentPatients = [];
                          List<Patient> walkInPatients = [];
                          List<Patient> newPatients = [];

                          if (arrivalState is ArrivalLoadedState) {
                            onAppointmentPatients = arrivalState
                                .onAppointmentArrivals
                                .map((arrival) => arrival.patient)
                                .toList();

                            walkInPatients = arrivalState.walkInArrivals
                                .map((arrival) => arrival.patient)
                                .toList();
                          }

                          if (appointmentState is AppointmentLoading ||
                              patientState is PatientLoading) {
                            // Display default values while loading
                            return Column(
                              children: [
                                _buildInfoCards([], walkInPatients, newPatients,
                                    onAppointmentPatients),
                                SizedBox(height: 20),
                                _buildDetailGrid([], walkInPatients,
                                    newPatients, onAppointmentPatients),
                              ],
                            );
                          } else if (appointmentState is AppointmentLoaded &&
                              patientState is TodaysPatientsLoaded) {
                            final appointments = appointmentState.appointments;

                            // Convert newPatients from dynamic to Patient
                            newPatients = (patientState as TodaysPatientsLoaded)
                                .todaysPatients
                                .map((e) => e as Patient)
                                .toList();

                            return Column(
                              children: [
                                _buildInfoCards(appointments, walkInPatients,
                                    newPatients, onAppointmentPatients),
                                SizedBox(height: 20),
                                _buildDetailGrid(appointments, walkInPatients,
                                    newPatients, onAppointmentPatients),
                              ],
                            );
                          } else if (appointmentState is AppointmentError) {
                            return Text('Error: ${appointmentState.message}');
                          } else if (patientState is PatientError) {
                            return Text('Error: ${patientState.message}');
                          } else {
                            return Text('Unexpected state');
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Dashboard'),
      centerTitle: true,
      backgroundColor: Color(0xFF6ABEDC),
    );
  }

  Widget _buildInfoCards(
      List<Appointment> appointments,
      List<Patient> walkInPatients,
      List<Patient> newPatients,
      List<Patient> onAppointmentPatients) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InfoCard(
          title: 'Today\'s Appointment',
          count: appointments.length,
          icon: Icons.person,
          color: Colors.red,
        ),
        InfoCard(
          title: 'Arrived Patient',
          count: onAppointmentPatients.length,
          icon: Icons.person_outline,
          color: Color.fromARGB(255, 7, 118, 179),
        ),
        InfoCard(
          title: 'Walk-In Patients',
          count: walkInPatients.length,
          icon: Icons.person_outline,
          color: Colors.orange,
        ),
        InfoCard(
          title: 'New Patients',
          count: newPatients.length,
          icon: Icons.person_add,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildDetailGrid(
      List<Appointment> appointments,
      List<Patient> walkInPatients,
      List<Patient> newPatients,
      List<Patient> onAppointmentPatients) {
    return StaggeredGrid.count(
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        DetailCard(
          title: 'Today\'s Appointment',
          appointments: appointments,
        ),
        DetailCard(
          title: 'Today\'s Walk-In Patients',
          patients: walkInPatients,
        ),
        DetailCard(
          title: 'Today\'s New Patients',
          patients: newPatients,
        ),
        DetailCard(
          title: 'Arrived Patient',
          patients: onAppointmentPatients,
        ),
      ],
    );
  }
}
