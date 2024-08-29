import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import 'add_dental_history_dialog.dart'; // Import the dialog

class PastDentalHistorySection extends StatelessWidget {
  final List<PastDentalHistory>? pastDentalHistory;
  final Patient patient; // Add patient property

  PastDentalHistorySection({
    required this.patient,
    this.pastDentalHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.all(8.0), // Adjust margin
            elevation: 0.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Adjust border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Adjust padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Past Dental History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Adjust font size
                          color: Colors.blueGrey[800],
                        ),
                  ),
                  SizedBox(height: 12), // Adjust spacing
                  if (pastDentalHistory == null || pastDentalHistory!.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(4.0), // Adjust padding
                      child: Text(
                        'No past dental history available.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12, // Adjust font size
                              color: Colors.blueGrey[600],
                            ),
                      ),
                    )
                  else
                    Column(
                      children: pastDentalHistory!.map((entry) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0), // Adjust vertical margin
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
                                      fontSize: 12, // Adjust font size
                                      color: Colors.blueGrey[700],
                                    ),
                              ),
                              SizedBox(height: 2), // Adjust spacing
                              Text(
                                entry.fieldValue.isNotEmpty
                                    ? entry.fieldValue
                                    : 'No additional information',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 12, // Adjust font size
                                      color: Colors.blueGrey[500],
                                    ),
                              ),
                              SizedBox(height: 8), // Adjust spacing
                              Divider(
                                color: Colors.blueGrey[300],
                                thickness: 1, // Adjust thickness
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
          Positioned(
            top: 8.0,
            right: 8.0,
            child: FloatingActionButton(
              onPressed: () {
                showAddDentalHistoryDialog(
                  context,
                  patient, // Pass the Patient object
                  () {
                    // Refresh or update the UI after adding
                  },
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue, // Custom background color
              foregroundColor: Colors.white, // Custom icon color
              mini: true, // Smaller size for the button
              tooltip: 'Add Dental History',
            ),
          ),
        ],
      ),
    );
  }
}
