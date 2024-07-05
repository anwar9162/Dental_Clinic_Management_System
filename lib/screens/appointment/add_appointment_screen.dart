import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../widgets/navigation_drawer.dart' as custom;

class AddAppointmentScreen extends StatefulWidget {
  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _doctorNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newAppointment = Appointment(
        id: DateTime.now().toString(),
        patientName: _patientNameController.text,
        date: _selectedDate,
        description: _descriptionController.text,
        doctorName: _doctorNameController.text,
      );
      Navigator.pop(context, newAppointment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
      ),
      drawer: custom.NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _doctorNameController,
                decoration: InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
