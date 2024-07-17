import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle the form submission
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Add Doctor'),
      ),*/
      backgroundColor: Colors.white, // Set the background color to white

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
                    return 'Please enter the doctor\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specialtyController,
                decoration: InputDecoration(labelText: 'Specialty'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor\'s specialty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
