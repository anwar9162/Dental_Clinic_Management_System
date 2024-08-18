import 'package:flutter/material.dart';
import 'list_tile.dart'; // Make sure this import is correct
import '../../models/appointment_model.dart';
import '../../models/patient_model.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final List<Appointment>? appointments;
  final List<Patient>? patients;

  const DetailCard({
    required this.title,
    this.appointments,
    this.patients,
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
              Color.fromARGB(255, 198, 243, 211),
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
                        title:
                            appointment.patientDetails?.firstName ?? 'Unknown',
                        subtitle1:
                            'Last Name: ${appointment.patientDetails?.lastName ?? 'N/A'}',
                        subtitle2:
                            'Gender: ${appointment.patientDetails?.gender ?? 'N/A'}',
                        subtitle3:
                            'Date of Birth: ${appointment.patientDetails?.dateOfBirth?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                      );
                    } else {
                      // Handle the patient item
                      final patientIndex = index - (appointments?.length ?? 0);
                      final patient = patients![patientIndex];
                      return ListTileWidget(
                        title: patient.firstName,
                        subtitle1: 'Last Name: ${patient.lastName}',
                        subtitle2: 'Gender: ${patient.gender ?? 'N/A'}',
                        subtitle3:
                            'Date of Birth: ${patient.dateOfBirth?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
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
}
