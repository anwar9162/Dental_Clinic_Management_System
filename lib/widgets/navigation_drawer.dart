import 'package:flutter/material.dart';
import '../models/patient_model.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final Function(String, {Object? arguments}) onMenuTap;
  final String selectedRoute; // Add this to keep track of the selected route

  CustomNavigationDrawer(
      {required this.onMenuTap, required this.selectedRoute});

  @override
  Widget build(BuildContext context) {
    // Define your new colors
    final Color primaryColor = Color(0xFF6ABEDC); // Soft Blue
    final Color selectedColor = Color(0xFF4A9CBB); // Darker Blue for selected
    final Color subColor = Color(0xFF8CC0D8); // Lighter Blue for sub-items

    return Container(
      width: 250, // Set a fixed width for the navigation drawer
      color: primaryColor, // Primary color for the drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor, // Match the drawer color
            ),
            child: Text(
              'Dental Management',
              style: TextStyle(
                color: Colors.white, // Text color
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
            tileColor: selectedRoute == '/' ? selectedColor : null,
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
            backgroundColor:
                selectedRoute.startsWith('/patient') ? selectedColor : null,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.medical_information, color: Colors.white),
                title: Text('Medical Information',
                    style: TextStyle(color: Colors.white)),
                tileColor:
                    selectedRoute == '/medical-information' ? subColor : null,
                onTap: () => onMenuTap('/medical-information'),
              ),
              ListTile(
                leading: Icon(Icons.add, color: Colors.white),
                title:
                    Text('Patient List', style: TextStyle(color: Colors.white)),
                tileColor: selectedRoute == '/patient-lists' ? subColor : null,
                onTap: () => onMenuTap('/patient-lists'),
              ),
            ],
          ),
          Divider(color: Colors.white54),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.white),
            title: Text('Manage Appointments (List)',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor: selectedRoute == '/appointments' ? selectedColor : null,
            onTap: () => onMenuTap('/appointments'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_month, color: Colors.white),
            title: Text('Manage Appointments (Calendar)',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor:
                selectedRoute == '/appointment-calendar' ? selectedColor : null,
            onTap: () => onMenuTap('/appointment-calendar'),
          ),
          ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.white),
            title: Text('Manage Doctors',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor: selectedRoute == '/doctors' ? selectedColor : null,
            onTap: () => onMenuTap('/doctors'),
          ),
          Divider(color: Colors.white54),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white),
            title: Text('Patient Record',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor: selectedRoute == '/patientrecord' ? selectedColor : null,
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
            title: Text('Telemedicine',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            tileColor: selectedRoute == '/Telemedicine' ? selectedColor : null,
            onTap: () => onMenuTap('/Telemedicine'),
          ),
        ],
      ),
    );
  }
}
