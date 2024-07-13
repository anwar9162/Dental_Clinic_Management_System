import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firstVisitDateController = TextEditingController();
  final _lastTreatmentController = TextEditingController();
  final _currentAppointmentReasonController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle the form submission
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient'),
      ),
      drawer: CustomNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstVisitDateController,
                decoration: InputDecoration(labelText: 'First Visit Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first visit date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastTreatmentController,
                decoration: InputDecoration(labelText: 'Last Treatment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last treatment';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _currentAppointmentReasonController,
                decoration:
                    InputDecoration(labelText: 'Current Appointment Reason'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the current appointment reason';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
