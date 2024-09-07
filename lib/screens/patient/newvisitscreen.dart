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
    'date': TextEditingController(), // Visit Date
    'description': TextEditingController(),
    'onset': TextEditingController(),
    'bloodPressure': TextEditingController(),
    'temperature': TextEditingController(),
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
    'pastMedicalHistory': TextEditingController(),
    'pastDentalHistory': TextEditingController(),
    'progressNoteDate':
        TextEditingController(), // Separate controller for Progress Note Date
  };

  final PatientApiService _apiService = PatientApiService();

  @override
  void initState() {
    super.initState();
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _controllers['date']!.text = todayDate;
    _controllers['progressNoteDate']!.text =
        todayDate; // Initialize separate controller
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
        'chiefComplaint': {
          'description': _controllers['description']!.text.isNotEmpty
              ? _controllers['description']!.text
              : 'N/A',
        },
        'historyOfPresentIllness': {
          'onset': _controllers['onset']!.text.isNotEmpty
              ? _controllers['onset']!.text
              : 'N/A',
        },
        'physicalExamination': {
          'bloodPressure': _controllers['bloodPressure']!.text.isNotEmpty
              ? _controllers['bloodPressure']!.text
              : 'N/A',
          'temperature': _controllers['temperature']!.text.isNotEmpty
              ? _controllers['temperature']!.text
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
          'completionDate': _controllers['completionDate']!.text.isNotEmpty
              ? _controllers['completionDate']!.text
              : 'N/A',
        },
        'progressNotes': [
          {
            'note': _controllers['note']!.text.isNotEmpty
                ? _controllers['note']!.text
                : 'N/A',
            'createdAt': _controllers['progressNoteDate']!
                .text, // Use separate date controller
          }
        ],
        'pastMedicalHistory':
            _controllers['pastMedicalHistory']!.text.isNotEmpty
                ? _controllers['pastMedicalHistory']!.text.split('\n')
                : [],
        'pastDentalHistory': _controllers['pastDentalHistory']!.text.isNotEmpty
            ? _controllers['pastDentalHistory']!.text.split('\n')
            : [],
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

  Widget _buildMultiColumnSections(double screenWidth) {
    final sectionData = {
      'Chief Complaint': [
        _buildTextFormField(_controllers['description']!, 'Description'),
      ],
      'History of Present Illness': [
        _buildTextFormField(_controllers['onset']!, 'Onset'),
      ],
      'Physical Examination': [
        _buildTextFormField(_controllers['bloodPressure']!, 'Blood Pressure'),
        _buildTextFormField(_controllers['temperature']!, 'Temperature'),
      ],
      'General Appearance': [
        _buildTextFormField(_controllers['appearance']!, 'Appearance'),
        _buildTextFormField(
            _controllers['additionalNotes']!, 'Additional Notes'),
      ],
      'Extra Oral Findings': [
        _buildTextFormField(_controllers['extraOralFindings']!, 'Findings'),
      ],
      'Internal Oral Findings': [
        _buildTextFormField(_controllers['internalOralFindings']!, 'Findings'),
      ],
      'Diagnosis': [
        _buildTextFormField(_controllers['condition']!, 'Condition'),
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
        _buildTextFormField(_controllers['progressNoteDate']!, 'Date'),
      ],
      'Past Medical History': [
        _buildTextFormField(
            _controllers['pastMedicalHistory']!, 'Medical History'),
      ],
      'Past Dental History': [
        _buildTextFormField(
            _controllers['pastDentalHistory']!, 'Dental History'),
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sectionData.entries.map<Widget>((entry) {
        final sectionTitle = entry.key;
        final fields = entry.value;

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
              ),
              SizedBox(height: 8),
              ...fields,
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
