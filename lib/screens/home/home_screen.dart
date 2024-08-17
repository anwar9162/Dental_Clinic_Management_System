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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Trigger fetching today's appointments when the widget is built
    BlocProvider.of<AppointmentBloc>(context).add(FetchTodaysAppointments());

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoCards(context),
                SizedBox(height: 20),
                _buildDetailGrid(context),
              ],
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

  Widget _buildInfoCards(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AppointmentLoaded) {
          final appointments = state.appointments;
          final walkInPatients = [
            Patient(
              firstName: "Kibrom",
              lastName: "Adinew",
              phoneNumber: "0712345678",
            ),
          ]; // Mock data for walk-in patients
          final newPatients = [
            Patient(
              firstName: "Kibrom",
              lastName: "Adinew",
              phoneNumber: "0712345678",
            ),
          ]; // Mock data for new patients

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
            ],
          );
        } else if (state is AppointmentError) {
          return Text('Error: ${state.message}');
        } else {
          return Text('Unexpected state');
        }
      },
    );
  }

  Widget _buildDetailGrid(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AppointmentLoaded) {
          final appointments = state.appointments;
          final walkInPatients = [
            Patient(
              firstName: "Kibrom",
              lastName: "Adinew",
              phoneNumber: "0712345678",
            ),
          ]; // Mock data for walk-in patients
          final newPatients = [
            Patient(
              firstName: "Kibrom",
              lastName: "Adinew",
              phoneNumber: "0712345678",
            ),
          ]; // Mock data for new patients

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
            ],
          );
        } else if (state is AppointmentError) {
          return Text('Error: ${state.message}');
        } else {
          return Text('Unexpected state');
        }
      },
    );
  }
}
