import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dental Clinic Management'),
      ),
      drawer: custom.NavigationDrawer(), // Use the alias here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/patients');
              },
              child: Text('Manage Patients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/appointments');
              },
              child: Text('Manage Appointments'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doctors');
              },
              child: Text('Manage Doctors'),
            ),
          ],
        ),
      ),
    );
  }
}
