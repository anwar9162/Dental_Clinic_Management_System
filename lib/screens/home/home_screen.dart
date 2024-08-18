import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import '../../utils/constants.dart'; // Import the constants file
import 'info_card.dart';
import 'detail_card.dart';
import '../appointment/blocs/appointment_bloc.dart';
import '../appointment/blocs/appointment_event.dart';
import '../appointment/blocs/appointment_state.dart';
import '../patient/patient_bloc/patient_bloc.dart'; // Import the patient BLoC
import '../patient/patient_bloc/patient_state.dart';
import '../patient/patient_bloc/patient_event.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Trigger fetching today's appointments and patients when the widget is built
    BlocProvider.of<AppointmentBloc>(context).add(FetchTodaysAppointments());
    BlocProvider.of<PatientBloc>(context).add(LoadTodaysPatients());

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, appointmentState) {
                return BlocBuilder<PatientBloc, PatientState>(
                  builder: (context, patientState) {
                    // Define mock data
                    final mockArrivedPatients = [
                      Patient(
                        firstName: "Jane",
                        lastName: "Doe",
                        phoneNumber: "0123456789",
                      ),
                      Patient(
                        firstName: "John",
                        lastName: "Smith",
                        phoneNumber: "0987654321",
                      ),
                    ];

                    final mockWalkInPatients = [
                      Patient(
                        firstName: "Hikmet",
                        lastName: "Johnson",
                        phoneNumber: "0123456789",
                      ),
                    ];

                    if (appointmentState is AppointmentLoading ||
                        patientState is PatientLoading) {
                      // Display default values while loading
                      return Column(
                        children: [
                          _buildInfoCards(
                              [], mockWalkInPatients, [], mockArrivedPatients),
                          SizedBox(height: 20),
                          _buildDetailGrid(
                              [], mockWalkInPatients, [], mockArrivedPatients),
                        ],
                      );
                    } else if (appointmentState is AppointmentLoaded &&
                        patientState is TodaysPatientsLoaded) {
                      final appointments = appointmentState.appointments;

                      // Convert newPatients from dynamic to Patient
                      final newPatients = (patientState as TodaysPatientsLoaded)
                          .todaysPatients
                          .map((e) => e as Patient)
                          .toList();

                      final walkInPatients =
                          mockWalkInPatients; // Use mock data here
                      final arrivedPatients = mockArrivedPatients;

                      return Column(
                        children: [
                          _buildInfoCards(appointments, walkInPatients,
                              newPatients, arrivedPatients),
                          SizedBox(height: 20),
                          _buildDetailGrid(appointments, walkInPatients,
                              newPatients, arrivedPatients),
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
      List<Patient> arrivedPatient) {
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
          count: arrivedPatient.length,
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
      List<Patient> arrivedPatient) {
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
          patients: arrivedPatient,
        ),
      ],
    );
  }
}
