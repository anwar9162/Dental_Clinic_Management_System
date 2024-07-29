import 'package:flutter/material.dart';

class AddPatientScreen extends StatefulWidget {
  final VoidCallback onClose;

  const AddPatientScreen({Key? key, required this.onClose}) : super(key: key);

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _patientType = 'New';

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle the form submission logic here
      widget.onClose();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dobController.text = _formatDate(pickedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.toLocal()}'.split(' ')[0]; // format date as YYYY-MM-DD
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          width: 700, // Increased width for the container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNameFields(),
                        SizedBox(height: 16),
                        _buildLabeledTextField('Phone Number', _phoneController,
                            keyboardType: TextInputType.phone),
                        SizedBox(height: 16),
                        _buildLabeledDropdownField(
                            'Gender', _genderController, ['Male', 'Female']),
                        SizedBox(height: 16),
                        _buildLabeledDateField('Date of Birth', _dobController),
                        SizedBox(height: 16),
                        _buildLabeledTextField('Address', _addressController),
                        SizedBox(height: 24),
                        _buildHiddenPatientTypeField(),
                        SizedBox(height: 24),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Patient',
            style: TextStyle(
              fontSize: 22, // Slightly larger size
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please fill in the details below to add a new patient.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16, // Slightly larger size
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildLabeledTextField('First Name', _firstNameController),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildLabeledTextField('Last Name', _lastNameController),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150, // Fixed width for labels
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none, // Remove border line
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDropdownField(
      String label, TextEditingController controller, List<String> options) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150, // Fixed width for labels
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: controller.text.isEmpty ? null : controller.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none, // Remove border line
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDateField(
      String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150, // Fixed width for labels
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none, // Remove border line
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.indigo),
            ),
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHiddenPatientTypeField() {
    return TextFormField(
      initialValue: _patientType,
      enabled: false,
      style: TextStyle(color: Colors.transparent), // Hide text
      decoration: InputDecoration.collapsed(hintText: 'Patient Type'),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 184, 201, 199), // Modern color
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5, // Subtle shadow for a modern effect
          ),
          child: Text(
            'Add Patient',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: widget.onClose,
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.teal, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
