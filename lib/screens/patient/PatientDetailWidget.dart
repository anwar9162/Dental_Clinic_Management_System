import 'package:flutter/material.dart';
import '../../models/basic_patient_info_model.dart'; // Update import path

class PatientDetailWidget extends StatelessWidget {
  final PatientBasicInfo patientBasicInfo;

  const PatientDetailWidget({required this.patientBasicInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${patientBasicInfo.firstName} ${patientBasicInfo.lastName}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Phone: ${patientBasicInfo.phoneNumber}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
