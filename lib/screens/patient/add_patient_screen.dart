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
        'gender': _genderController.text,
        'address': _addressController.text,
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
              constraints: BoxConstraints(maxWidth: 500), // Reduced max width
              padding: const EdgeInsets.all(12.0), // Reduced padding
              decoration: _boxDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12.0), // Reduced padding
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNameFields(),
                            SizedBox(height: 12), // Reduced height
                            _buildLabeledTextField(
                              'Phone Number',
                              _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 12), // Reduced height
                            _buildLabeledDropdownField(
                              'Gender',
                              _genderController,
                              ['Male', 'Female'],
                            ),
                            SizedBox(height: 12), // Reduced height
                            _buildLabeledDateField(
                              'Date of Birth',
                              _dobController,
                            ),
                            SizedBox(height: 12), // Reduced height
                            _buildLabeledTextField(
                              'Address',
                              _addressController,
                            ),
                            SizedBox(height: 16), // Reduced height
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
            Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: [Colors.blue, Colors.green, Colors.red],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Patient',
            style: _headerTextStyle,
          ),
          SizedBox(height: 6), // Reduced height
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
      children: [
        Expanded(
          flex: 3, // Adjusted flex to make fields wider
          child: _buildLabeledTextField('First Name', _firstNameController),
        ),
        SizedBox(width: 8), // Reduced width
        Expanded(
          flex: 3, // Adjusted flex to make fields wider
          child: _buildLabeledTextField('Last Name', _lastNameController),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Reduced width
            child: Text(
              label,
              style: _labelTextStyle,
            ),
          ),
          SizedBox(width: 8), // Reduced width
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: _inputDecoration,
              validator: (value) => _validateField(value, label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledDropdownField(
      String label, TextEditingController controller, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Reduced width
            child: Text(
              label,
              style: _labelTextStyle,
            ),
          ),
          SizedBox(width: 8), // Reduced width
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
      ),
    );
  }

  Widget _buildLabeledDateField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Reduced width
            child: Text(
              label,
              style: _labelTextStyle,
            ),
          ),
          SizedBox(width: 8), // Reduced width
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
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: widget.onClose,
          style: TextButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 251, 251, 251), // Subtle grey color for cancel
            textStyle: TextStyle(fontSize: 14), // Reduced font size
          ),
          child: Text('Cancel'),
        ),
        SizedBox(width: 8), // Reduced width
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 157, 192, 221), // Vibrant blue color for add patient
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 8), // Reduced padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Reduced border radius
            ),
            elevation: 4, // Reduced elevation
          ),
          child: Text('Add Patient',
              style: TextStyle(fontSize: 14)), // Reduced font size
        ),
      ],
    );
  }

  // Helper Methods
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
        borderRadius: BorderRadius.circular(6), // Reduced border radius
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(
          vertical: 12.0, horizontal: 8.0), // Adjusted padding
    );
  }

  TextStyle get _headerTextStyle {
    return TextStyle(
      fontSize: 18, // Reduced font size
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  TextStyle get _subHeaderTextStyle {
    return TextStyle(
      color: Colors.grey[600],
      fontSize: 14, // Reduced font size
    );
  }

  TextStyle get _labelTextStyle {
    return TextStyle(
      fontSize: 14, // Reduced font size
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  BoxDecoration get _boxDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10), // Reduced border radius
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8, // Reduced blur radius
          offset: Offset(0, 4), // Reduced offset
        ),
      ],
    );
  }
}
