import 'package:flutter/material.dart';
import '../../models/patient_model.dart';

class PastMedicalHistorySection extends StatelessWidget {
  final List<PastMedicalHistory>? pastMedicalHistory;

  PastMedicalHistorySection({this.pastMedicalHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Card(
        margin: EdgeInsets.all(8.0), // Reduced margin
        elevation: 0.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Reduced border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past Medical History',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Reduced font size
                      color: Colors.blueGrey[800],
                    ),
              ),
              SizedBox(height: 12), // Reduced spacing
              if (pastMedicalHistory == null || pastMedicalHistory!.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(4.0), // Reduced padding
                  child: Text(
                    'No past medical history available.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12, // Reduced font size
                          color: Colors.blueGrey[600],
                        ),
                  ),
                )
              else
                Column(
                  children: pastMedicalHistory!.map((entry) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 4.0), // Reduced vertical margin
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.fieldName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12, // Reduced font size
                                  color: Colors.blueGrey[700],
                                ),
                          ),
                          SizedBox(height: 2), // Reduced spacing
                          Text(
                            entry.fieldValue.isNotEmpty
                                ? entry.fieldValue
                                : 'No additional information',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12, // Reduced font size
                                      color: Colors.blueGrey[500],
                                    ),
                          ),
                          SizedBox(height: 8), // Reduced spacing
                          Divider(
                            color: Colors.blueGrey[300],
                            thickness: 1, // Thinner divider
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
