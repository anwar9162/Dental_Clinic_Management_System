import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import 'add_appointment_screen.dart';
import 'appointment_detail_screen.dart';
import '../../widgets/navigation_drawer.dart' as custom;
import '../../widgets/appointment_card.dart';

class AppointmentListScreen extends StatefulWidget {
  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      patientName: 'John Doe',
      doctorName: 'Dr. Smith',
      date: DateTime.now(),
      time: '10:00 AM',
      description: 'Regular checkup',
    ),
    Appointment(
      id: '2',
      patientName: 'Jane Smith',
      doctorName: 'Dr. Adams',
      date: DateTime.now().add(Duration(days: 1)),
      time: '11:00 AM',
      description: 'Teeth cleaning',
    ),
  ];

  void _addNewAppointment(Appointment newAppointment) {
    setState(() {
      _appointments.add(newAppointment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment List'),
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
            _addNewAppointment(newAppointment);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
