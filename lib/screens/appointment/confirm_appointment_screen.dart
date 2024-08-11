import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import '../../models/appointment_model.dart';

void showConfirmAppointmentDialog({
  required BuildContext context,
  required Patient selectedPatient,
  required Map<String, dynamic> selectedDoctor, // Map to hold doctor info
  required DateTime selectedDate,
  required String appointmentReason,
  required List<String> notes, // List<String> to hold notes
  required VoidCallback onConfirm,
}) {
  print("Dialog is being shown."); // Add this line

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Patient: ${selectedPatient.firstName} ${selectedPatient.lastName}'),
            SizedBox(height: 8.0),
            Text('Doctor: ${selectedDoctor['name']}'),
            SizedBox(height: 8.0),
            Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 8.0),
            Text('Reason: ASDF'),
            SizedBox(height: 8.0),
            Text('Notes:'),
            ...notes.map((note) => Text('- $note')).toList(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Confirm'),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
