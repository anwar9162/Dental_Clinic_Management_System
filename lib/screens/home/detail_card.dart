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

  const DetailCard({
    required this.title,
    this.appointments,
    this.patients,
    this.arrivals, // Added for arrival times
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 252, 252, 252),
              Color.fromARGB(255, 244, 248, 245),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount:
                      (appointments?.length ?? 0) + (patients?.length ?? 0),
                  itemBuilder: (context, index) {
                    if (index < (appointments?.length ?? 0)) {
                      // Handle the appointment item
                      final appointment = appointments![index];
                      return ListTileWidget(
                        firstName:
                            appointment.patientDetails?.firstName ?? 'Unknown',
                        lastName: appointment.patientDetails?.lastName ?? 'N/A',
                        gender: appointment.patientDetails?.gender ?? 'N/A',
                        dateOfBirth: appointment.patientDetails?.dateOfBirth
                                ?.toLocal()
                                .toString()
                                .split(' ')[0] ??
                            'N/A',
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal), // Set text to bold
                      );
                    } else {
                      // Handle the patient item
                      final patientIndex = index - (appointments?.length ?? 0);
                      final patient = patients![patientIndex];
                      final arrival = arrivals?.firstWhere(
                        (a) => a.patient.id == patient.id,
                        orElse: () => Arrival(
                          id: '',
                          patient: patient,
                          arrivalTime: DateTime.now(),
                          arrivalType: '',
                        ),
                      );
                      return ListTile(
                        title: Row(
                          children: [
                            Text(patient.firstName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(
                                width:
                                    8), // Space between first name and last name
                            Text(patient.lastName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Arrival Time: ${_formatTime(arrival?.arrivalTime ?? DateTime.now())}',
                                style: TextStyle(fontSize: 14)),
                            Text('Note: ${arrival!.notes ?? 'N/A'}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onDelete(patient),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
