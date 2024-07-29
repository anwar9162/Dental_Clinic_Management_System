import 'package:flutter/material.dart';
import 'add_patient_screen.dart';
import 'add_arrived_patient_screen.dart';

class ArrivedAndNewPatientScreen extends StatelessWidget {
  void _handleClose() {
    // Handle the close action
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Patient'),
          backgroundColor: Colors.teal,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Add Patient'),
              Tab(text: 'Arrived Patient'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddPatientScreen(onClose: _handleClose), // Pass onClose function
            AddArrivedPatientScreen(
                onClose: _handleClose), // Pass onClose function
          ],
        ),
      ),
    );
  }
}
