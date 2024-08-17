import 'package:flutter/material.dart';
import 'list_tile.dart';
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
                      final appointment = appointments![index];
                      return ListTileWidget(
                        title: appointment.patientDetails!.firstName,
                        subtitle1:
                            'Phone number: ${appointment.patientDetails!.phoneNumber}',
                        subtitle2: 'Current Appointment: ',
                        subtitle3: 'Days Since First Visit: 50 days',
                      );
                    } else {
                      final patient =
                          patients![index - (appointments?.length ?? 0)];
                      return ListTileWidget(
                        title: patient.firstName ?? 'Unknown',
                        subtitle1: 'Days Since First Visit: 300 days',
                        subtitle2: '', // Add placeholders for empty subtitles
                        subtitle3: '',
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

  int _daysSinceFirstVisit(DateTime? firstVisitDate) {
    if (firstVisitDate == null) {
      return 0;
    }
    return DateTime.now().difference(firstVisitDate).inDays;
  }
}
