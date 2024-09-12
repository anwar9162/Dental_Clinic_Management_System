import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import 'package:intl/intl.dart';

class EditVisitScreen extends StatefulWidget {
  final Visit visit;
  final String patientID;

  EditVisitScreen({required this.visit, required this.patientID});

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

    // Initialize controllers for past medical history
    _pastMedicalHistoryControllers = (widget.visit.pastMedicalHistory ?? [])
        .map((history) => TextEditingController(text: history.fieldValue))
        .toList();

    // Initialize controllers for past dental history
    _pastDentalHistoryControllers = (widget.visit.pastDentalHistory ?? [])
        .map((history) => TextEditingController(text: history.fieldValue))
        .toList();
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _historyOfPresentIllnessController.dispose();
    _bloodpressureController.dispose();
    _temperatureController.dispose();
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
        title: Text('Edit Hx - patient ID: ${widget.patientID}'),
        backgroundColor: Color(0xFF6ABEDC),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
    print('Building right column');

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
                          'fieldValue': history.fieldValue,
                        })
                    .toList() ??
                [],
            'Medical History',
            _removePastMedicalHistory),
        _buildSectionHeader('Past Dental History'),
        _buildDynamicTextFields(
            widget.visit.pastDentalHistory
                    ?.map((history) => {
                          'fieldName': history.fieldName,
                          'fieldValue': history.fieldValue,
                        })
                    .toList() ??
                [],
            'Dental History',
            _removePastDentalHistory),
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
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _treatmentPlanControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Planned Treatment ${index + 1}',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: null,
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _treatmentPlanControllers.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreatmentDoneFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        _treatmentDoneControllers.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _treatmentDoneControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Treatment Done ${index + 1}',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: null,
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _treatmentDoneControllers.removeAt(index);
                  });
                },
              ),
            ],
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
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    controller: _progressNoteControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Progress Note ${index + 1}',
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
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _progressNoteControllers.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removePastMedicalHistory(int index) {
    setState(() {
      widget.visit.pastMedicalHistory?.removeAt(index);
      _pastMedicalHistoryControllers.removeAt(index);
    });
  }

  void _removePastDentalHistory(int index) {
    print('Removing Past Dental History at index: $index');
    print('Before removal: ${widget.visit.pastDentalHistory}');

    setState(() {
      widget.visit.pastDentalHistory?.removeAt(index);
      _pastDentalHistoryControllers.removeAt(index);
    });

    print('After removal: ${widget.visit.pastDentalHistory}');
  }

  Widget _buildDynamicTextFields(
      List<Map<String, String>> items, String label, Function(int) onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            key: ValueKey(
                'dynamic_${item['fieldName']}_$index'), // Unique key for each entry
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: item['fieldName'],
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      item['fieldName'] = value; // Update the item in the list
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: item['fieldValue'],
                  decoration: InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      item['fieldValue'] = value; // Update the item in the list
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  onRemove(index); // Call the removal function
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTwoColumnFields(
      List<TreatmentEntry> items, String label1, String label2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            key: ValueKey('treatment_${item.treatment}_${index}'),
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
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    items.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGeneralAppearanceDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InputDecorator(
        decoration: InputDecoration(
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
