import 'package:flutter/material.dart';

class AddArrivedPatientScreen extends StatefulWidget {
  final VoidCallback onClose;

  AddArrivedPatientScreen({required this.onClose});

  @override
  _AddArrivedPatientScreenState createState() =>
      _AddArrivedPatientScreenState();
}

class _AddArrivedPatientScreenState extends State<AddArrivedPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  final _notesController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle the form submission logic here
      // Example: Mark the patient as arrived
      widget.onClose(); // Close the form after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Name', _nameController),
                      _buildTextField('Arrival Time', _arrivalTimeController,
                          keyboardType: TextInputType.datetime),
                      _buildTextField('Notes', _notesController),
                      SizedBox(height: 16),
                      _buildSubmitButton(),
                      SizedBox(height: 12),
                      _buildCancelButton(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Text(
        'Add Arrived Patient',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text('Mark as Arrived', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: widget.onClose,
      child: Text('Cancel', style: TextStyle(color: Colors.teal)),
    );
  }
}
