import 'package:flutter/material.dart';
import 'list_tile.dart'; // Ensure this import is correct
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';
import 'models/arrival_model.dart'; // Import Arrival model

class DetailCard extends StatelessWidget {
  final String title;
  final List<Appointment>? appointments;
  final List<Patient>? patients;
  final List<Arrival>? arrivals; // Added for arrival times
  final Function(Patient) onDelete;
  final bool isNewPatientCard; // Flag to handle new patients differently

  const DetailCard({
    required this.title,
    this.appointments,
    this.patients,
    this.arrivals,
    required this.onDelete,
    this.isNewPatientCard = false, // Default to false if not specified
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              // Create a List of widgets to be displayed
              Wrap(
                spacing: 8.0, // Horizontal spacing between widgets
                runSpacing: 8.0, // Vertical spacing between lines
                children: [
                  if (appointments != null && appointments!.isNotEmpty) ...[
                    for (var appointment in appointments!)
                      _buildAppointmentWidget(context, appointment),
                  ],
                  if (patients != null && patients!.isNotEmpty) ...[
                    for (var patient in patients!)
                      _buildPatientWidget(context, patient),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentWidget(
      BuildContext context, Appointment appointment) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2, // Adjust width
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTileWidget(
          firstName: appointment.patientDetails?.firstName ?? 'Unknown',
          lastName: appointment.patientDetails?.lastName ?? 'N/A',
          gender: appointment.patientDetails?.gender ?? 'N/A',
          dateOfBirth: appointment.patientDetails?.dateOfBirth
                  ?.toLocal()
                  .toString()
                  .split(' ')[0] ??
              'N/A',
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientWidget(BuildContext context, Patient patient) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2, // Adjust width
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Icon(Icons.person, color: Colors.blue),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  '${patient.firstName} ${patient.lastName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${patient.phoneNumber}', // Removed "Phone:" label
            style: TextStyle(fontSize: 14, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: isNewPatientCard
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0), // Reduced padding
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(patient),
                  ),
                ),
        ),
      ),
    );
  }
}
