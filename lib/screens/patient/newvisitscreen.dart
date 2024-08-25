import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewVisitScreen extends StatefulWidget {
  @override
  _NewVisitScreenState createState() => _NewVisitScreenState();

  static void showAddVisitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white, // Set dialog background to pure white
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Slightly reduced radius
          ),
          child: NewVisitScreen(),
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
    'amount': TextEditingController(),
    'datePayment': TextEditingController(),
    'status': TextEditingController(),
    'reasonPayment': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _controllers['date']!.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white, // Ensure container background is pure white
      padding: const EdgeInsets.all(16.0), // Reduced padding
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
            SizedBox(height: 4), // Reduced height
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateAndReasonFields(),
                  SizedBox(height: 8),
                  _buildMultiColumnSections(screenWidth),
                  SizedBox(height: 8), // Reduced height
                  Divider(color: Colors.grey[400]),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12.0), // Reduced padding
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
                        SizedBox(width: 12), // Reduced width
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Handle save action
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  6.0), // Slightly reduced radius
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

  Widget _buildDateAndReasonFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFormField(_controllers['date']!, 'Visit Date'),
        ),
        SizedBox(width: 8), // Reduced width
        Expanded(
          child:
              _buildTextFormField(_controllers['reason']!, 'Reason for Visit'),
        ),
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
        _buildDropdownField(_controllers['appearance']!, 'Appearance',
            ['Well-Looking', 'Acute Sick-Looking']),
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
        _buildTextFormField(_controllers['datePayment']!, 'Date'),
      ],
      'Payment': [
        _buildTextFormField(_controllers['amount']!, 'Amount'),
        _buildTextFormField(_controllers['datePayment']!, 'Date'),
        _buildDropdownField(_controllers['status']!, 'Status',
            ['Pending', 'Cancelled', 'Paid']),
        _buildTextFormField(_controllers['reasonPayment']!, 'Reason'),
      ],
    };

    return Column(
      children: sectionData.entries.map((entry) {
        final sectionTitle = entry.key;
        final sectionFields = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 4.0), // Reduced vertical padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(sectionTitle),
              SizedBox(height: 4), // Reduced space between title and fields
              ...sectionFields,
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 8.0), // Reduced padding
      color: Colors.white, // Ensure section title background is white
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.0, // Reduced font size
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding
      child: Row(
        children: [
          SizedBox(
            width: 120, // Fixed width for labels
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
              height: 40, // Set a fixed height
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType ?? TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(6.0), // Slightly reduced radius
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set text field background to white
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
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
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced padding
      child: Row(
        children: [
          SizedBox(
            width: 120, // Fixed width for labels
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
              height: 40, // Set a fixed height
              child: DropdownButtonFormField<String>(
                value: controller.text.isNotEmpty ? controller.text : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(6.0), // Slightly reduced radius
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set dropdown background to white
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
