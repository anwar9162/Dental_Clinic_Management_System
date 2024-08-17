import 'package:flutter/material.dart';
import '../../models/patient_model.dart';

class PastMedicalHistorySection extends StatelessWidget {
  final List<PastMedicalHistory>? pastMedicalHistory;

  PastMedicalHistorySection({this.pastMedicalHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width of the parent
      color: Colors.white, // White background for the section
      child: Card(
        margin: EdgeInsets.all(16.0),
        elevation: 0.0, // No shadow for a flat design
        color: Colors.white, // White background for the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Padding for spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past Medical History',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800], // Professional color
                    ),
              ),
              SizedBox(height: 20),
              if (pastMedicalHistory == null || pastMedicalHistory!.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No past medical history available.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.blueGrey[600], // Professional color
                        ),
                  ),
                )
              else
                Column(
                  children: pastMedicalHistory!.map((entry) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.fieldName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors
                                      .blueGrey[700], // Professional color
                                ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            entry.fieldValue.isNotEmpty
                                ? entry.fieldValue
                                : 'No additional information',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors
                                      .blueGrey[500], // Professional color
                                ),
                          ),
                          SizedBox(height: 16), // Spacing between entries
                          Divider(
                            color: Colors
                                .blueGrey[300], // Subtle divider for separation
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
