import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class CustomNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Dental Clinic Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Manage Patients'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/patients');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Manage Appointments (List)'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/appointments');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month),
            title: Text('Manage Appointments (Calendar)'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/appointment-calendar');
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Manage Doctors'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/doctors');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Manage Billing'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/billing');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Patient Record'),
            onTap: () {
              Navigator.pushNamed(
                context,
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
        ],
      ),
    );
  }
}
