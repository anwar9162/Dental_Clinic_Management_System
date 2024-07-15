import 'package:flutter/material.dart';

class AddPatientScreen extends StatefulWidget {
  final VoidCallback onClose;

  AddPatientScreen({required this.onClose});

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
      // Handle the form submission logic here
      // Example: Add the patient data to the list
      // After submission, close the form
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 700), // Increased max width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                'Add New Patient',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Name', _nameController),
                      _buildTextField(
                          'First Visit Date', _firstVisitDateController,
                          keyboardType: TextInputType.datetime),
                      _buildTextField(
                          'Last Treatment', _lastTreatmentController),
                      _buildTextField('Current Appointment Reason',
                          _currentAppointmentReasonController),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            Text('Add Patient', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 12),
                      TextButton(
                        onPressed: widget.onClose,
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.teal)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
