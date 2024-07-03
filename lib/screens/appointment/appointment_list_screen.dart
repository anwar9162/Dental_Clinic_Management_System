import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../widgets/appointment_card.dart';
import '../../widgets/navigation_drawer.dart' as custom;
import './add_appointment_screen.dart';
import './appointment_detail_screen.dart';

class AppointmentListScreen extends StatelessWidget {
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'John Doe',
      date: DateTime.now(),
      description: 'Routine check-up',
      doctorName: 'Dr. Smith',
    ),
    Appointment(
      id: '2',
      patientName: 'Jane Doe',
      date: DateTime.now().add(Duration(days: 1)),
      description: 'Teeth cleaning',
      doctorName: 'Dr. Brown',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      drawer: custom.NavigationDrawer(),
      body: ListView.builder(
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          return AppointmentCard(
            appointment: _appointments[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentDetailScreen(
                      appointment: _appointments[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAppointment = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAppointmentScreen()),
          );

          if (newAppointment != null) {
            _appointments.add(newAppointment);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
