import 'package:dental_management_main/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/patient_api_service.dart'; // Adjust the import path as needed

class NewVisitScreen extends StatefulWidget {
  final Patient patient;

  NewVisitScreen({required this.patient});

  @override
  _NewVisitScreenState createState() => _NewVisitScreenState();

  static void showAddVisitDialog(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: NewVisitScreen(patient: patient),
        );
      },
    );
  }
}

class _NewVisitScreenState extends State<NewVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'date': TextEditingController(),
    'reason': TextEditingController(),
    'description': TextEditingController(),
    'duration': TextEditingController(),
    'severity': TextEditingController(),
    'onset': TextEditingController(),
    'progression': TextEditingController(),
    'associatedSymptoms': TextEditingController(),
    'bloodPressure': TextEditingController(),
    'temperature': TextEditingController(),
    'pulse': TextEditingController(),
    'respirationRate': TextEditingController(),
    'appearance': TextEditingController(),
    'additionalNotes': TextEditingController(),
    'extraOralFindings': TextEditingController(),
    'internalOralFindings': TextEditingController(),
    'condition': TextEditingController(),
    'details': TextEditingController(),
    'plannedTreatments': TextEditingController(),
    'followUpInstructions': TextEditingController(),
    'treatments': TextEditingController(),
    'completionDate': TextEditingController(),
    'note': TextEditingController(),
  };

  final PatientApiService _apiService = PatientApiService();

  @override
  void initState() {
    super.initState();
    // Set today's date as default value
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _controllers['date']!.text = todayDate;
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final visitData = {
        'date': _controllers['date']!.text,
        'reason': _controllers['reason']!.text.isNotEmpty
            ? _controllers['reason']!.text
            : 'N/A',
        'chiefComplaint': {
          'description': _controllers['description']!.text.isNotEmpty
              ? _controllers['description']!.text
              : 'N/A',
          'duration': _controllers['duration']!.text.isNotEmpty
              ? _controllers['duration']!.text
              : 'N/A',
          'severity': _controllers['severity']!.text.isNotEmpty
              ? _controllers['severity']!.text
              : 'N/A',
        },
        'historyOfPresentIllness': {
          'onset': _controllers['onset']!.text.isNotEmpty
              ? _controllers['onset']!.text
              : 'N/A',
          'progression': _controllers['progression']!.text.isNotEmpty
              ? _controllers['progression']!.text
              : 'N/A',
          'associatedSymptoms':
              _controllers['associatedSymptoms']!.text.isNotEmpty
                  ? _controllers['associatedSymptoms']!.text
                  : 'N/A',
        },
        'physicalExamination': {
          'bloodPressure': _controllers['bloodPressure']!.text.isNotEmpty
              ? _controllers['bloodPressure']!.text
              : 'N/A',
          'temperature': _controllers['temperature']!.text.isNotEmpty
              ? _controllers['temperature']!.text
              : 'N/A',
          'pulse': _controllers['pulse']!.text.isNotEmpty
              ? _controllers['pulse']!.text
              : 'N/A',
          'respirationRate': _controllers['respirationRate']!.text.isNotEmpty
              ? _controllers['respirationRate']!.text
              : 'N/A',
        },
        'generalAppearance': {
          'appearance': _controllers['appearance']!.text.isNotEmpty
              ? _controllers['appearance']!.text
              : 'Acute Sick-Looking',
          'additionalNotes': _controllers['additionalNotes']!.text.isNotEmpty
              ? _controllers['additionalNotes']!.text
              : 'N/A',
        },
        'extraOral': _controllers['extraOralFindings']!.text.isNotEmpty
            ? _controllers['extraOralFindings']!.text
            : null,
        'internalOral': {
          'findings': _controllers['internalOralFindings']!.text.isNotEmpty
              ? _controllers['internalOralFindings']!.text
              : 'N/A',
        },
        'diagnosis': _controllers['condition']!.text.isNotEmpty
            ? _controllers['condition']!.text
            : null,
        'treatmentPlan': {
          'plannedTreatments': [
            _controllers['plannedTreatments']!.text.isNotEmpty
                ? _controllers['plannedTreatments']!.text
                : 'N/A'
          ],
          'followUpInstructions':
              _controllers['followUpInstructions']!.text.isNotEmpty
                  ? _controllers['followUpInstructions']!.text
                  : 'N/A',
        },
        'treatmentDone': {
          'treatments': [
            _controllers['treatments']!.text.isNotEmpty
                ? _controllers['treatments']!.text
                : 'N/A'
          ],
          'completionDate': _controllers['date']!.text,
        },
        'progressNotes': [
          {
            'note': _controllers['note']!.text.isNotEmpty
                ? _controllers['note']!.text
                : 'N/A',
            'createdAt': _controllers['date']!.text,
          }
        ],
        'progressImages': [],
        'xrayImages': [],
      };

      try {
        await _apiService.addVisitRecord(widget.patient.id!, visitData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Visit record added successfully!'),
        ));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add visit record: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      width: screenWidth * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add New Visit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
            ),
            SizedBox(height: 4),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateField(),
                  SizedBox(height: 8),
                  _buildReasonField(),
                  SizedBox(height: 8),
                  _buildMultiColumnSections(screenWidth),
                  SizedBox(height: 8),
                  Divider(color: Colors.grey[400]),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _handleSave,
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            'Visit Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextFormField(
              controller: _controllers['date']!,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Date is required';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonField() {
    return Row(
      children: [
        Expanded(
            child: _buildTextFormField(
                _controllers['reason']!, 'Reason for Visit')),
      ],
    );
  }

  Widget _buildMultiColumnSections(double screenWidth) {
    final sectionData = {
      'Chief Complaint': [
        _buildTextFormField(_controllers['description']!, 'Description'),
        _buildTextFormField(_controllers['duration']!, 'Duration'),
        _buildTextFormField(_controllers['severity']!, 'Severity'),
      ],
      'History of Present Illness': [
        _buildTextFormField(_controllers['onset']!, 'Onset'),
        _buildTextFormField(_controllers['progression']!, 'Progression'),
        _buildTextFormField(
            _controllers['associatedSymptoms']!, 'Associated Symptoms'),
      ],
      'Physical Examination': [
        _buildTextFormField(_controllers['bloodPressure']!, 'Blood Pressure'),
        _buildTextFormField(_controllers['temperature']!, 'Temperature'),
        _buildTextFormField(_controllers['pulse']!, 'Pulse'),
        _buildTextFormField(
            _controllers['respirationRate']!, 'Respiration Rate'),
      ],
      'General Appearance': [
        _buildTextFormField(_controllers['appearance']!, 'Appearance'),
        _buildTextFormField(
            _controllers['additionalNotes']!, 'Additional Notes'),
      ],
      'Extra Oral Examination': [
        _buildTextFormField(_controllers['extraOralFindings']!, 'Findings'),
      ],
      'Internal Oral Examination': [
        _buildTextFormField(_controllers['internalOralFindings']!, 'Findings'),
      ],
      'Diagnosis': [
        _buildTextFormField(_controllers['condition']!, 'Condition'),
        _buildTextFormField(_controllers['details']!, 'Details'),
      ],
      'Treatment Plan': [
        _buildTextFormField(
            _controllers['plannedTreatments']!, 'Planned Treatments'),
        _buildTextFormField(
            _controllers['followUpInstructions']!, 'Follow-Up Instructions'),
      ],
      'Treatment Done': [
        _buildTextFormField(_controllers['treatments']!, 'Treatments'),
        _buildTextFormField(_controllers['completionDate']!, 'Completion Date'),
      ],
      'Progress Notes': [
        _buildTextFormField(_controllers['note']!, 'Note'),
        _buildTextFormField(_controllers['date']!, 'Date'),
      ],
    };

    return Column(
      children: sectionData.entries.map((entry) {
        final sectionTitle = entry.key;
        final sectionFields = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(sectionTitle),
              SizedBox(height: 4),
              ...sectionFields,
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      color: Colors.white,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // No error, let the handleSave handle the default value
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      TextEditingController controller, String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: DropdownButtonFormField<String>(
                value: controller.text.isNotEmpty ? controller.text : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    controller.text = newValue ?? '';
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
          ),
        ],
      ),
    );
  }
}
