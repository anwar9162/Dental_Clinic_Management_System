import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';

Future<void> showConfirmAppointmentDialog({
  required BuildContext context,
  required Patient selectedPatient,
  required Map<String, dynamic> selectedDoctor,
  required DateTime selectedDate,
  required String appointmentReason,
  required List<String> notes,
  required Function onConfirm,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to close
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'Confirm Appointment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF6ABEDC), // Using your specified color
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              _buildPatientInfo(selectedPatient),
              Divider(color: Colors.grey[300]), // Light divider color
              _buildDoctorInfo(selectedDoctor),
              Divider(color: Colors.grey[300]),
              _buildAppointmentDetails(selectedDate, appointmentReason, notes),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style:
                  TextStyle(color: Colors.grey[700]), // Subtle color for cancel
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm(); // Call the confirmation function
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              backgroundColor:
                  Color(0xFF6ABEDC), // Button color using your specified color
              foregroundColor: Colors.white, // Text color
            ),
            child: Text(
              'Confirm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildPatientInfo(Patient patient) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Patient Information',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF6ABEDC), // Using your specified color
        ),
      ),
      SizedBox(height: 8),
      Text('Name: ${patient.firstName} ${patient.lastName}'),
      Text('Patient ID: ${patient.id}'),
      SizedBox(height: 12),
    ],
  );
}

Widget _buildDoctorInfo(Map<String, dynamic> doctor) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Doctor Information',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF6ABEDC), // Using your specified color
        ),
      ),
      SizedBox(height: 8),
      Text('Name: ${doctor['name']}'),
      Text('Doctor ID: ${doctor['_id']}'),
      SizedBox(height: 12),
    ],
  );
}

Widget _buildAppointmentDetails(
    DateTime date, String reason, List<String> notes) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Appointment Details',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF6ABEDC), // Using your specified color
        ),
      ),
      SizedBox(height: 8),
      Text('Date: ${date.toLocal().toString().split(' ')[0]}'),
      Text('Reason: $reason'),
      SizedBox(height: 8),
      Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
      ...notes.map((note) => Text('• $note')).toList(),
    ],
  );
}
