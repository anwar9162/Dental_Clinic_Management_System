import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final Function(String, {Object? arguments}) onMenuTap;

  CustomNavigationDrawer({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Set a fixed width for the navigation drawer
      color: Colors.teal,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Hospital Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuTap('/'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title:
                Text('Manage Patients', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuTap('/patients'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.white),
            title: Text('Manage Appointments (List)',
                style: TextStyle(color: Colors.white)),
            onTap: () => onMenuTap('/appointments'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month, color: Colors.white),
            title: Text('Manage Appointments (Calendar)',
                style: TextStyle(color: Colors.white)),
            onTap: () => onMenuTap('/appointment-calendar'),
          ),
          ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.white),
            title:
                Text('Manage Doctors', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuTap('/doctors'),
          ),
          /*
          ListTile(
            leading: Icon(Icons.payment, color: Colors.white),
            title: Text('Manage Billing', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuTap('/billing'),
          ),*/
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white),
            title:
                Text('Patient Record', style: TextStyle(color: Colors.white)),
            onTap: () {
              onMenuTap(
                '/patientrecord',
                arguments: Patient(
                  id: '1',
                  name: 'John Doe',
                  firstVisitDate: DateTime(2023, 1, 1),
                  lastTreatment: 'Cleaning',
                  currentAppointmentReason: 'Routine Checkup',
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.videocam, color: Colors.white),
            title: Text('Tele Medicine', style: TextStyle(color: Colors.white)),

            onTap: () =>
                onMenuTap('/Telemedicine'), // Corrected onTap assignment
          ),
        ],
      ),
    );
  }
}
