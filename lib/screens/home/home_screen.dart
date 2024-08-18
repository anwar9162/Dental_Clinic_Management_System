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
                          List<Patient> onAppointmentPatients = [];
                          List<Patient> walkInPatients = [];
                          List<Patient> newPatients = [];
                          List<Arrival> onAppointmentArrivals = [];
                          List<Arrival> walkInArrivals = [];

                          if (arrivalState is ArrivalLoadedState) {
                            onAppointmentArrivals =
                                arrivalState.onAppointmentArrivals;
                            walkInArrivals = arrivalState.walkInArrivals;
                            onAppointmentPatients = onAppointmentArrivals
                                .map((arrival) => arrival.patient)
                                .toList();
                            walkInPatients = walkInArrivals
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
                                    newPatients, onAppointmentPatients, [], []),
                              ],
                            );
                          } else if (appointmentState is AppointmentLoaded &&
                              patientState is TodaysPatientsLoaded) {
                            final appointments = appointmentState.appointments;

                            newPatients = (patientState as TodaysPatientsLoaded)
                                .todaysPatients
                                .map((e) => e as Patient)
                                .toList();

                            return Column(
                              children: [
                                _buildInfoCards(appointments, walkInPatients,
                                    newPatients, onAppointmentPatients),
                                SizedBox(height: 20),
                                _buildDetailGrid(
                                    appointments,
                                    walkInPatients,
                                    newPatients,
                                    onAppointmentPatients,
                                    onAppointmentArrivals,
                                    walkInArrivals),
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
        InfoCard(
          title: 'Arrived Patient',
          count: onAppointmentPatients.length,
          icon: Icons.person_outline,
          color: Color.fromARGB(255, 7, 118, 179),
        ),
      ],
    );
  }

  Widget _buildDetailGrid(
      List<Appointment> appointments,
      List<Patient> walkInPatients,
      List<Patient> newPatients,
      List<Patient> onAppointmentPatients,
      List<Arrival> onAppointmentArrivals,
      List<Arrival> walkInArrivals) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        DetailCard(
          title: 'Today\'s Appointment',
          appointments: appointments,
          onDelete: (patient) {
            // Handle delete action for appointments if needed
          },
        ),
        DetailCard(
          title: 'Today\'s Walk-In Patients',
          patients: walkInPatients,
          arrivals: walkInArrivals, // Pass arrivals for walk-in patients
          onDelete: (patient) async {
            final arrival =
                walkInArrivals.firstWhere((a) => a.patient.id == patient.id);
            bool? confirmDelete = await _showConfirmationDialog(context);
            if (confirmDelete ?? false) {
              context.read<ArrivalBloc>().add(DeleteArrivalEvent(arrival.id));
            }
          },
        ),
        DetailCard(
          title: 'Today\'s New Patients',
          patients: newPatients,
          onDelete: (patient) {
            // Handle delete action for new patients if needed
          },
        ),
        DetailCard(
          title: 'Arrived Patient',
          patients: onAppointmentPatients,
          arrivals:
              onAppointmentArrivals, // Pass arrivals for on-appointment patients
          onDelete: (patient) async {
            final arrival = onAppointmentArrivals
                .firstWhere((a) => a.patient.id == patient.id);
            bool? confirmDelete = await _showConfirmationDialog(context);
            if (confirmDelete ?? false) {
              context.read<ArrivalBloc>().add(DeleteArrivalEvent(arrival.id));
            }
          },
        ),
      ],
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
