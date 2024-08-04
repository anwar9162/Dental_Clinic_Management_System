import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../patient/patient_bloc/add_patient_bloc.dart';
import '../patient/patient_bloc/add_patient_event.dart';
import '../patient/patient_bloc/add_patient_state.dart';

import '../../services/patient_api_service.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AddPatientScreen extends StatelessWidget {
  final VoidCallback onClose;

  const AddPatientScreen({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPatientBloc(PatientApiService()),
      child: _AddPatientForm(onClose: onClose),
    );
  }
}

class _AddPatientForm extends StatefulWidget {
  final VoidCallback onClose;

  const _AddPatientForm({Key? key, required this.onClose}) : super(key: key);

  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<_AddPatientForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _patientType = 'New';

  bool _isLoading = false;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final patientData = {
        'phoneNumber': _phoneController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'dateOfBirth': _dobController.text,
        'Gender': _genderController.text,
        'Address': _addressController.text,
        'patientType': _patientType,
      };

      context.read<AddPatientBloc>().add(SubmitPatientForm(patientData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPatientBloc, AddPatientState>(
      listener: (context, state) {
        if (state is AddPatientLoading) {
          setState(() => _isLoading = true);
        } else if (state is AddPatientSuccess) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Patient added successfully')),
          );
          widget.onClose();
        } else if (state is AddPatientFailure) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add patient: ${state.error}')),
          );
        }
      },
      child: Stack(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 600),
              decoration: _boxDecoration,
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
                            _buildLabeledTextField(
                                'Phone Number', _phoneController,
                                keyboardType: TextInputType.phone),
                            SizedBox(height: 16),
                            _buildLabeledDropdownField('Gender',
                                _genderController, ['Male', 'Female']),
                            SizedBox(height: 16),
                            _buildLabeledDateField(
                                'Date of Birth', _dobController),
                            SizedBox(height: 16),
                            _buildLabeledTextField(
                                'Address', _addressController),
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
          if (_isLoading)
            Center(
              child: Container(
                color: Colors.black
                    .withOpacity(0.4), // Slightly transparent background
                child: Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator
                        .ballPulse, // Change this to your desired indicator type
                    colors: [
                      Colors.blue,
                      Colors.green,
                      Colors.red
                    ], // Add more colors if desired
                    strokeWidth: 2,
                    backgroundColor:
                        Colors.transparent, // Transparent background
                  ),
                ),
              ),
            ),
        ],
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
            style: _headerTextStyle,
          ),
          SizedBox(height: 8),
          Text(
            'Please fill in the details below to add a new patient.',
            style: _subHeaderTextStyle,
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
            child: _buildLabeledTextField('First Name', _firstNameController)),
        SizedBox(width: 16),
        Expanded(
            child: _buildLabeledTextField('Last Name', _lastNameController)),
      ],
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLabel(label),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: _inputDecoration,
            validator: (value) => _validateField(value, label),
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
        _buildLabel(label),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: controller.text.isEmpty ? null : controller.text,
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                controller.text = value!;
              });
            },
            decoration: _inputDecoration,
            validator: (value) => _validateField(value, label),
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
        _buildLabel(label),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  controller.text = _formatDate(pickedDate);
                });
              }
            },
            decoration: _inputDecoration,
            validator: (value) => _validateField(value, label),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onClose,
          child: Text('Cancel'),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Add Patient'),
        ),
      ],
    );
  }

  // Helper Methods
  Widget _buildLabel(String label) {
    return SizedBox(
      width: 150,
      child: Text(
        label,
        style: _labelTextStyle,
      ),
    );
  }

  String? _validateField(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  InputDecoration get _inputDecoration {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  TextStyle get _headerTextStyle {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  TextStyle get _subHeaderTextStyle {
    return TextStyle(
      color: Colors.grey[600],
      fontSize: 16,
    );
  }

  TextStyle get _labelTextStyle {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  BoxDecoration get _boxDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    );
  }
}
