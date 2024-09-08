import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dental_management_main/models/patient_model.dart';
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
  final PatientApiService _apiService = PatientApiService();

  final Map<String, TextEditingController> _controllers = {
    'date': TextEditingController(),
    'chiefComplaintDescription': TextEditingController(),
    'hpiDetail': TextEditingController(),
    'bloodPressure': TextEditingController(),
    'temperature': TextEditingController(),
    'appearance': TextEditingController(),
    'extraOral': TextEditingController(),
    'intraOral': TextEditingController(),
    'plannedTreatments': TextEditingController(),
    'treatment': TextEditingController(),
    'completionDate': TextEditingController(),
    'progressNote1': TextEditingController(),
    'progressNote2': TextEditingController(),
    'progressNote3': TextEditingController(),
    'medicalHistory1Name': TextEditingController(),
    'medicalHistory1Value': TextEditingController(),
    'medicalHistory2Name': TextEditingController(),
    'medicalHistory2Value': TextEditingController(),
    'dentalHistory1Name': TextEditingController(),
    'dentalHistory1Value': TextEditingController(),
    'dentalHistory2Name': TextEditingController(),
    'dentalHistory2Value': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _controllers['date']!.text = todayDate;
    _controllers['completionDate']!.text = todayDate;
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final visitData = {
        "date": _controllers['date']!.text,
        "chiefComplaint": {
          "description": _controllers['chiefComplaintDescription']!.text,
        },
        "historyOfPresentIllness": {
          "Detail": _controllers['hpiDetail']!.text,
        },
        "physicalExamination": {
          "bloodPressure": _controllers['bloodPressure']!.text,
          "temperature": _controllers['temperature']!.text,
        },
        "generalAppearance": {
          "appearance": _controllers['appearance']!.text,
        },
        'extraOral': {
          'findings': _controllers['extraOral']!.text,
        },
        "intraOral": {
          "findings": _controllers['intraOral']!.text,
        },
        "diagnosis": null,
        "treatmentPlan": {
          "plannedTreatments": [
            _controllers['plannedTreatments']!.text,
          ],
        },
        "treatmentDone": [
          {
            "treatment": _controllers['treatment']!.text,
            "completionDate": _controllers['completionDate']!.text,
          },
        ],
        "progressNotes": [
          {
            "note": _controllers['progressNote1']!.text,
          },
          {
            "note": _controllers['progressNote2']!.text,
          },
          {
            "note": _controllers['progressNote3']!.text,
          },
        ],
        "pastMedicalHistory": [
          {
            "fieldName": _controllers['medicalHistory1Name']!.text,
            "fieldValue": _controllers['medicalHistory1Value']!.text,
          },
          {
            "fieldName": _controllers['medicalHistory2Name']!.text,
            "fieldValue": _controllers['medicalHistory2Value']!.text,
          },
        ],
        "pastDentalHistory": [
          {
            "fieldName": _controllers['dentalHistory1Name']!.text,
            "fieldValue": _controllers['dentalHistory1Value']!.text,
          },
          {
            "fieldName": _controllers['dentalHistory2Name']!.text,
            "fieldValue": _controllers['dentalHistory2Value']!.text,
          },
        ],
      };

      try {
        await _apiService.addVisitRecord(widget.patient.id!, visitData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Visit record added successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add visit record: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Visit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 2,
                          child: _buildLeftColumn()), // Left column is narrower
                      SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child:
                              _buildMiddleColumn()), // Middle column size remains the same
                      SizedBox(width: 16),
                      Expanded(
                          flex: 6,
                          child: _buildRightColumn()), // Right column is wider
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLeftColumn(),
                      SizedBox(height: 16),
                      _buildMiddleColumn(),
                      SizedBox(height: 16),
                      _buildRightColumn(),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Visit Information'),
        _buildTextField('date', 'Visit Date', readOnly: true),
        _buildSectionHeader('Chief Complaint'),
        _buildTextField(
            'chiefComplaintDescription', 'Description of Complaint'),
        _buildSectionHeader('Physical Examination'),
        _buildTextField('bloodPressure', 'Blood Pressure'),
        _buildTextField('temperature', 'Temperature'),
        _buildSectionHeader('Extra-Oral Examination'),
        _buildTextField('extraOral', 'Findings'),
        _buildSectionHeader('Intra-Oral Examination'),
        _buildTextField('intraOral', 'Findings'),
      ],
    );
  }

  Widget _buildMiddleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('History of Present Illness'),
        _buildTextField('hpiDetail', 'Detail of HPI'),
        _buildSectionHeader('General Appearance'),
        _buildTextField('appearance', 'Appearance'),
        _buildSectionHeader('Treatment Done'),
        _buildTextField('treatment', 'Treatment Done'),
        _buildTextField('completionDate', 'Completion Date'),
        _buildSectionHeader('Treatment Plan'),
        _buildTextField('plannedTreatments', 'Planned Treatments'),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Past Medical History'),
        _buildFieldNameValueRow(
            'medicalHistory1Name', 'medicalHistory1Value', 'Medical History 1'),
        _buildFieldNameValueRow(
            'medicalHistory2Name', 'medicalHistory2Value', 'Medical History 2'),
        _buildSectionHeader('Past Dental History'),
        _buildFieldNameValueRow(
            'dentalHistory1Name', 'dentalHistory1Value', 'Dental History 1'),
        _buildFieldNameValueRow(
            'dentalHistory2Name', 'dentalHistory2Value', 'Dental History 2'),
        _buildSectionHeader('Progress Notes'),
        _buildTextField('progressNote1', 'Progress Note 1'),
        _buildTextField('progressNote2', 'Progress Note 2'),
        _buildTextField('progressNote3', 'Progress Note 3'),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        readOnly: readOnly,
        validator: (value) {
          if (!readOnly && (value == null || value.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildFieldNameValueRow(
      String nameKey, String valueKey, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Field Name Input - Narrower
          Expanded(
            flex: 2, // Adjust this flex value to make the name field narrower
            child: TextFormField(
              controller: _controllers[nameKey],
              decoration: InputDecoration(
                labelText: 'Subject', // Update label to 'Subject'
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Subject is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 12),
          // Field Value Input - Wider
          Expanded(
            flex: 4, // Adjust this flex value to make the value field wider
            child: TextFormField(
              controller: _controllers[valueKey],
              decoration: InputDecoration(
                labelText: 'Details', // Update label to 'Details'
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Details are required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
