import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final Function(String, {Object? arguments}) onMenuTap;
  final String selectedRoute; // Add this to keep track of the selected route

  CustomNavigationDrawer(
      {required this.onMenuTap, required this.selectedRoute});

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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor: selectedRoute == '/' ? Colors.teal.shade700 : null,
            onTap: () => onMenuTap('/'),
          ),
          ExpansionTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text('Manage Patients',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.only(left: 16.0),
            backgroundColor: selectedRoute.startsWith('/patient')
                ? Colors.teal.shade700
                : null,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.medical_information, color: Colors.white),
                title: Text('Medical Information',
                    style: TextStyle(color: Colors.white)),
                tileColor: selectedRoute == '/medical-information'
                    ? Colors.teal.shade600
                    : null,
                onTap: () => onMenuTap('/medical-information'),
              ),
              ListTile(
                leading: Icon(Icons.add, color: Colors.white),
                title:
                    Text('Add Patient', style: TextStyle(color: Colors.white)),
                tileColor: selectedRoute == '/add_patient'
                    ? Colors.teal.shade600
                    : null,
                onTap: () => onMenuTap('/add_patient'),
              ),
            ],
          ),
          Divider(color: Colors.white54),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.white),
            title: Text('Manage Appointments (List)',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor:
                selectedRoute == '/appointments' ? Colors.teal.shade700 : null,
            onTap: () => onMenuTap('/appointments'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month, color: Colors.white),
            title: Text('Manage Appointments (Calendar)',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor: selectedRoute == '/appointment-calendar'
                ? Colors.teal.shade700
                : null,
            onTap: () => onMenuTap('/appointment-calendar'),
          ),
          ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.white),
            title: Text('Manage Doctors',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor:
                selectedRoute == '/doctors' ? Colors.teal.shade700 : null,
            onTap: () => onMenuTap('/doctors'),
          ),
          Divider(color: Colors.white54),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white),
            title: Text('Patient Record',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor:
                selectedRoute == '/patientrecord' ? Colors.teal.shade700 : null,
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
            title: Text('Tele Medicine',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor:
                selectedRoute == '/Telemedicine' ? Colors.teal.shade700 : null,
            onTap: () => onMenuTap('/Telemedicine'),
          ),
        ],
      ),
    );
  }
}
