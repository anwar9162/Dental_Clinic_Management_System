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
    'completionDate': TextEditingController(),
  };

  List<Map<String, TextEditingController>> _plannedTreatments = [
    {'treatment': TextEditingController()},
  ];

  List<Map<String, TextEditingController>> _treatmentDone = [
    {
      'treatment': TextEditingController(),
      'completionDate': TextEditingController()
    },
  ];

  List<Map<String, TextEditingController>> _progressNotes = [
    {'note': TextEditingController()},
  ];

  List<Map<String, TextEditingController>> _pastMedicalHistory = [
    {'name': TextEditingController(), 'value': TextEditingController()},
  ];

  List<Map<String, TextEditingController>> _pastDentalHistory = [
    {'name': TextEditingController(), 'value': TextEditingController()},
  ];

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

  void _addPlannedTreatmentField() {
    setState(() {
      _plannedTreatments.add({
        'treatment': TextEditingController(),
      });
    });
  }

  void _removePlannedTreatmentField(int index) {
    setState(() {
      _plannedTreatments[index]['treatment']!.dispose();
      _plannedTreatments.removeAt(index);
    });
  }

  void _addTreatmentDoneField() {
    setState(() {
      _treatmentDone.add({
        'treatment': TextEditingController(),
        'completionDate': TextEditingController(),
      });
    });
  }

  void _removeTreatmentDoneField(int index) {
    setState(() {
      _treatmentDone[index]['treatment']!.dispose();
      _treatmentDone[index]['completionDate']!.dispose();
      _treatmentDone.removeAt(index);
    });
  }

  void _addProgressNoteField() {
    setState(() {
      _progressNotes.add({
        'note': TextEditingController(),
      });
    });
  }

  void _removeProgressNoteField(int index) {
    setState(() {
      _progressNotes[index]['note']!.dispose();
      _progressNotes.removeAt(index);
    });
  }

  void _addPastMedicalHistoryField() {
    setState(() {
      _pastMedicalHistory.add({
        'name': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void _removePastMedicalHistoryField(int index) {
    setState(() {
      _pastMedicalHistory[index]['name']!.dispose();
      _pastMedicalHistory[index]['value']!.dispose();
      _pastMedicalHistory.removeAt(index);
    });
  }

  void _addPastDentalHistoryField() {
    setState(() {
      _pastDentalHistory.add({
        'name': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void _removePastDentalHistoryField(int index) {
    setState(() {
      _pastDentalHistory[index]['name']!.dispose();
      _pastDentalHistory[index]['value']!.dispose();
      _pastDentalHistory.removeAt(index);
    });
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
          "plannedTreatments": _plannedTreatments.map((entry) {
            return {
              "treatment": entry['treatment']!.text,
            };
          }).toList(),
        },
        "treatmentDone": _treatmentDone.map((entry) {
          return {
            "treatment": entry['treatment']!.text,
            "completionDate": entry['completionDate']!.text,
          };
        }).toList(),
        "progressNotes": _progressNotes.map((entry) {
          return {
            "note": entry['note']!.text,
          };
        }).toList(),
        "pastMedicalHistory": _pastMedicalHistory.map((entry) {
          return {
            "fieldName": entry['name']!.text,
            "fieldValue": entry['value']!.text,
          };
        }).toList(),
        "pastDentalHistory": _pastDentalHistory.map((entry) {
          return {
            "fieldName": entry['name']!.text,
            "fieldValue": entry['value']!.text,
          };
        }).toList(),
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
        title: Text('New Hx'),
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
        _buildGeneralAppearanceDropdown(), // Use DropdownButtonFormField here
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Treatment Done'),
        ..._treatmentDone.asMap().entries.map((entry) {
          int index = entry.key;
          return Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: entry.value['treatment'],
                  decoration: InputDecoration(
                    labelText: 'Treatment',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Treatment is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: entry.value['completionDate'],
                  decoration: InputDecoration(
                    labelText: 'Completion Date',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Completion Date is required';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removeTreatmentDoneField(index),
              ),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: _addTreatmentDoneField,
          child: Text('Add Treatment Done'),
        ),
        _buildSectionHeader('Treatment Plan'),
        ..._plannedTreatments.asMap().entries.map((entry) {
          int index = entry.key;
          return Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: entry.value['treatment'],
                  decoration: InputDecoration(
                    labelText: 'Planned Treatment',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Planned Treatment is required';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removePlannedTreatmentField(index),
              ),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: _addPlannedTreatmentField,
          child: Text('Add Planned Treatment'),
        ),
        _buildSectionHeader('Progress Notes'),
        ..._progressNotes.asMap().entries.map((entry) {
          int index = entry.key;
          return Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: entry.value['note'],
                  decoration: InputDecoration(
                    labelText: 'Progress Note',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Progress Note is required';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removeProgressNoteField(index),
              ),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: _addProgressNoteField,
          child: Text('Add Progress Note'),
        ),
        _buildSectionHeader('Past Medical History'),
        ..._pastMedicalHistory.asMap().entries.map((entry) {
          int index = entry.key;
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: entry.value['name'],
                  decoration: InputDecoration(
                    labelText: 'Subject',
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
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: entry.value['value'],
                  decoration: InputDecoration(
                    labelText: 'Details',
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
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removePastMedicalHistoryField(index),
              ),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: _addPastMedicalHistoryField,
          child: Text('Add Medical History'),
        ),
        _buildSectionHeader('Past Dental History'),
        ..._pastDentalHistory.asMap().entries.map((entry) {
          int index = entry.key;
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: entry.value['name'],
                  decoration: InputDecoration(
                    labelText: 'Subject',
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
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: entry.value['value'],
                  decoration: InputDecoration(
                    labelText: 'Details',
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
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removePastDentalHistoryField(index),
              ),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: _addPastDentalHistoryField,
          child: Text('Add Dental History'),
        ),
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

  Widget _buildGeneralAppearanceDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Appearance',
          labelStyle: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _controllers['appearance']!.text.isEmpty
                ? null
                : _controllers['appearance']!.text,
            hint: Text('Appearance'),
            items: [
              DropdownMenuItem<String>(
                value: 'Acute Sick-Looking',
                child: _buildDropdownItem('Acute Sick-Looking'),
              ),
              DropdownMenuItem<String>(
                value: 'Well-Looking',
                child: _buildDropdownItem('Well Looking'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _controllers['appearance']!.text = value ?? '';
              });
            },
            dropdownColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.palette, color: Colors.blueGrey[600]),
          SizedBox(width: 12.0),
          Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
