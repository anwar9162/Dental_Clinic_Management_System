import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import 'package:intl/intl.dart';

class EditVisitScreen extends StatefulWidget {
  final Visit visit;

  EditVisitScreen({required this.visit});

  @override
  _EditVisitScreenState createState() => _EditVisitScreenState();
}

class _EditVisitScreenState extends State<EditVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _chiefComplaintController;
  late TextEditingController _historyOfPresentIllnessController;
  late TextEditingController _bloodpressureController;
  late TextEditingController _temperatureController;

  late TextEditingController _generalAppearanceController;
  late TextEditingController _extraOralController;
  late TextEditingController _intraOralController;
  late TextEditingController _diagnosisController;
  late List<TextEditingController> _treatmentPlanControllers = [];
  late List<TextEditingController> _treatmentDoneControllers = [];
  late List<TextEditingController> _progressNoteControllers = [];
  late List<TextEditingController> _pastMedicalHistoryControllers = [];
  late List<TextEditingController> _pastDentalHistoryControllers = [];

  @override
  void initState() {
    super.initState();
    _chiefComplaintController = TextEditingController(
        text: widget.visit.chiefComplaint?.description ?? '');
    _historyOfPresentIllnessController = TextEditingController(
        text: widget.visit.historyOfPresentIllness?.Detail ?? '');
    _bloodpressureController = TextEditingController(
        text: widget.visit.physicalExamination?.bloodPressure ?? '');
    _temperatureController = TextEditingController(
        text: widget.visit.physicalExamination?.temperature ?? '');
    _generalAppearanceController = TextEditingController(
        text: widget.visit.generalAppearance?.appearance ?? '');
    _extraOralController =
        TextEditingController(text: widget.visit.extraOral?.findings ?? '');
    _intraOralController =
        TextEditingController(text: widget.visit.intraOral?.findings ?? '');
    _diagnosisController =
        TextEditingController(text: widget.visit.diagnosis?.condition ?? '');

    // Initialize controllers for treatment plan
    _treatmentPlanControllers = (widget
                .visit.treatmentPlan?.plannedTreatments ??
            [])
        .map((treatment) => TextEditingController(text: treatment.treatment))
        .toList();

    // Initialize controllers for treatment done
    _treatmentDoneControllers = (widget.visit.treatmentDone ?? [])
        .map((treatment) => TextEditingController(text: treatment.treatment))
        .toList();

    // Initialize controllers for progress notes
    _progressNoteControllers = (widget.visit.progressNotes ?? [])
        .map((note) => TextEditingController(text: note.note))
        .toList();
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _historyOfPresentIllnessController.dispose();
    _bloodpressureController.dispose();
    _generalAppearanceController.dispose();
    _extraOralController.dispose();
    _intraOralController.dispose();
    _diagnosisController.dispose();
    _treatmentPlanControllers.forEach((controller) => controller.dispose());
    _treatmentDoneControllers.forEach((controller) => controller.dispose());
    _progressNoteControllers.forEach((controller) => controller.dispose());
    _pastMedicalHistoryControllers
        .forEach((controller) => controller.dispose());
    _pastDentalHistoryControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Visit'),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
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
                          flex: 2, child: _buildLeftColumn()), // Left column
                      SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child: _buildMiddleColumn()), // Middle column
                      SizedBox(width: 16),
                      Expanded(
                          flex: 6, child: _buildRightColumn()), // Right column
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
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Chief Complaint'),
        _buildTextField(
            'Chief Complaint Description', _chiefComplaintController),
        _buildSectionHeader('Physical Examination'),
        _buildTextField('Blood Pressure', _bloodpressureController),
        _buildTextField('Temperature', _temperatureController),
        _buildSectionHeader('Extra-Oral Examination'),
        _buildTextField('Findings', _extraOralController),
        _buildSectionHeader('Intra-Oral Examination'),
        _buildTextField('Findings', _intraOralController),
      ],
    );
  }

  Widget _buildMiddleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('History of Present Illness'),
        _buildTextField('Detail of HPI', _historyOfPresentIllnessController),
        _buildSectionHeader('General Appearance'),
        _buildGeneralAppearanceDropdown(),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Treatment Done'),
        _buildTwoColumnFields(
            widget.visit.treatmentDone ?? [], 'Treatment', 'Completion Date'),
        _buildSectionHeader('Treatment Plan'),
        _buildTreatmentPlanFields(),
        _buildSectionHeader('Progress Notes'),
        _buildProgressNoteFields(),
        _buildSectionHeader('Past Medical History'),
        _buildDynamicTextFields(
            widget.visit.pastMedicalHistory
                    ?.map((history) => {
                          'fieldName': history.fieldName,
                          'fieldValue': history.fieldValue
                        })
                    .toList() ??
                [],
            'Medical History'),
        _buildSectionHeader('Past Dental History'),
        _buildDynamicTextFields(
            widget.visit.pastDentalHistory
                    ?.map((history) => {
                          'fieldName': history.fieldName,
                          'fieldValue': history.fieldValue
                        })
                    .toList() ??
                [],
            'Dental History'),
      ],
    );
  }

  Widget _buildTreatmentPlanFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        _treatmentPlanControllers.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextFormField(
            controller: _treatmentPlanControllers[index],
            decoration: InputDecoration(
              labelText: 'Planned Treatment ${index + 1}',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            maxLines: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Treatment is required';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProgressNoteFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        _progressNoteControllers.length,
        (index) {
          final progressNote = widget.visit.progressNotes?[index];
          final createdAt = progressNote?.createdAt ?? DateTime.now();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note ${index + 1}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 4),
                        TextFormField(
                          controller: _progressNoteControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Progress Note',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          maxLines: null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Progress Note is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created At',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        initialValue:
                            DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt),
                        decoration: InputDecoration(
                          labelText: 'Creation Date',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        //    readOnly: true, // Set to true to make it non-editable
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        maxLines: null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDynamicTextFields(
      List<Map<String, String>> items, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1, // Field Name takes up 1 part of the available space
                child: TextFormField(
                  initialValue: item['fieldName'],
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 3, // Field Value takes up 3 parts of the available space
                child: TextFormField(
                  initialValue: item['fieldValue'],
                  decoration: InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTwoColumnFields(
      List<TreatmentEntry> items, String label1, String label2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: item.treatment,
                  decoration: InputDecoration(
                    labelText: label1,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: item.completionDate != null
                      ? DateFormat('yyyy-MM-dd').format(item.completionDate!)
                      : '',
                  decoration: InputDecoration(
                    labelText: label2,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
            value: _generalAppearanceController.text.isEmpty
                ? null
                : _generalAppearanceController.text,
            hint: Text('Appearance'),
            items: [
              DropdownMenuItem<String>(
                value: 'Acute Sick-Looking',
                child: _buildDropdownItem('Acute Sick-Looking'),
              ),
              DropdownMenuItem<String>(
                value: 'Well-Looking',
                child: _buildDropdownItem('Well-Looking'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _generalAppearanceController.text = value ?? '';
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String text) {
    return Row(
      children: [
        Text(text),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save logic here
      // Update the visit object with data from the controllers
      Navigator.pop(context);
    }
  }
}
