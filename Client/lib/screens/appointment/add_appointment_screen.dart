import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';

class AddAppointmentScreen extends StatefulWidget {
  final Appointment? appointment;

  AddAppointmentScreen({this.appointment});

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();

  final _doctorNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _patientNameController.text = widget.appointment!.patientName!;

      _doctorNameController.text = widget.appointment!.doctorName!;
      _selectedDate = widget.appointment!.date;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newAppointment = Appointment(
        id: widget.appointment?.id ?? DateTime.now().toString(),
        patientName: _patientNameController.text,
        date: _selectedDate,
        doctorName: _doctorNameController.text,
      );
      Navigator.pop(context, newAppointment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appointment == null
            ? 'Add Appointment'
            : 'Edit Appointment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _doctorNameController,
                decoration: InputDecoration(
                  labelText: 'Doctor Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text("Appointment Date: ${_selectedDate.toLocal()}"
                    .split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
