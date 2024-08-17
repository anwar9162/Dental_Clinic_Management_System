import 'package:flutter/material.dart';
import '../../models/patient_model.dart';

class PastDentalHistorySection extends StatelessWidget {
  final List<PastDentalHistory>? pastDentalHistory;

  PastDentalHistorySection({this.pastDentalHistory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width of the parent
      color: Colors.white, // White background for the section
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Past Dental History',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800], // Professional color
                  ),
            ),
            SizedBox(height: 20),
            if (pastDentalHistory == null || pastDentalHistory!.isEmpty)
              Text(
                'No past dental history available.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.blueGrey[600], // Professional color
                    ),
              )
            else
              Column(
                children: pastDentalHistory!.map((entry) {
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
                                color:
                                    Colors.blueGrey[700], // Professional color
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
                                color:
                                    Colors.blueGrey[500], // Professional color
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
    );
  }
}
