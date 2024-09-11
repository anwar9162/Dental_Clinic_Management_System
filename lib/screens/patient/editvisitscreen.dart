import 'package:flutter/material.dart';
import '../../models/patient_model.dart';

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
  late TextEditingController _physicalExaminationController;
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
    _physicalExaminationController = TextEditingController(
        text: widget.visit.physicalExamination?.bloodPressure ?? '');
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

    // Initialize controllers for past medical history
    _pastMedicalHistoryControllers = (widget.visit.pastMedicalHistory ?? [])
        .map((history) => TextEditingController(
            text: '${history.fieldName}: ${history.fieldValue}'))
        .toList();

    // Initialize controllers for past dental history
    _pastDentalHistoryControllers = (widget.visit.pastDentalHistory ?? [])
        .map((history) => TextEditingController(
            text: '${history.fieldName}: ${history.fieldValue}'))
        .toList();
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _historyOfPresentIllnessController.dispose();
    _physicalExaminationController.dispose();
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
        _buildTextField('Blood Pressure', _physicalExaminationController),
        _buildTextField('Temperature',
            _physicalExaminationController), // Assuming it's part of the same controller
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
        _buildDynamicTextFields(_treatmentDoneControllers, 'Treatment Done'),
        _buildSectionHeader('Treatment Plan'),
        _buildDynamicTextFields(
            _treatmentPlanControllers, 'Planned Treatments'),
        _buildSectionHeader('Progress Notes'),
        _buildDynamicTextFields(_progressNoteControllers, 'Progress Note'),
        _buildSectionHeader('Past Medical History'),
        _buildDynamicTextFields(
            _pastMedicalHistoryControllers, 'Medical History'),
        _buildSectionHeader('Past Dental History'),
        _buildDynamicTextFields(
            _pastDentalHistoryControllers, 'Dental History'),
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
      List<TextEditingController> controllers, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: controllers.asMap().entries.map((entry) {
        int index = entry.key;
        TextEditingController controller = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: '$label ${index + 1}',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            maxLines: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label ${index + 1} is required';
              }
              return null;
            },
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
                value: 'Well-Looking ',
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
