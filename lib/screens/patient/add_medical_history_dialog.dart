import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../services/patient_api_service.dart'; // Import your service file

Future<void> showAddMedicalHistoryDialog(
    BuildContext context, Patient patient, Function() onSuccess) {
  final List<Map<String, String>> fields = [
    {'fieldName': '', 'fieldValue': ''}
  ]; // Initialize with one field
  final patientApiService =
      PatientApiService(); // Create an instance of the service

  void addField() {
    fields.add({'fieldName': '', 'fieldValue': ''});
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(16.0),
            title: Text('Add Medical History'),
            content: Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // Adjusted width for better fit
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...fields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'e.g., Allergies, Medications',
                                  labelText: 'Field Name',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    field['fieldName'] = value;
                                  });
                                },
                                autofocus: fields.indexOf(field) == 0,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'e.g., Penicillin, Insulin',
                                  labelText: 'Details',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                maxLines: null, // Allow multiple lines
                                keyboardType: TextInputType.multiline,
                                onChanged: (value) {
                                  setState(() {
                                    field['fieldValue'] = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        addField();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                      ),
                      child: Text('Add Another Field'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add', style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  final entries = fields
                      .where((field) =>
                          field['fieldName']?.isNotEmpty == true &&
                          field['fieldValue']?.isNotEmpty == true)
                      .map((field) => {
                            'fieldName': field['fieldName']!,
                            'fieldValue': field['fieldValue']!,
                            'patientId': patient.id ?? '',
                          })
                      .toList();

                  if (entries.isNotEmpty) {
                    try {
                      await patientApiService.addPastMedicalHistory(
                        patient.id ?? '',
                        entries,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Medical history added successfully.')),
                      );
                      onSuccess(); // Notify success
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
