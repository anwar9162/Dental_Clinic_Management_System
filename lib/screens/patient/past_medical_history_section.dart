import 'package:flutter/material.dart';
import '../../models/patient_model.dart';
import 'add_medical_history_dialog.dart'; // Import the dialog

class PastMedicalHistorySection extends StatefulWidget {
  final List<PastMedicalHistory> pastMedicalHistory;
  final Patient patient;

  PastMedicalHistorySection({
    Key? key,
    required this.pastMedicalHistory,
    required this.patient,
  }) : super(key: key);

  @override
  _PastMedicalHistorySectionState createState() =>
      _PastMedicalHistorySectionState();
}

class _PastMedicalHistorySectionState extends State<PastMedicalHistorySection> {
  void _addMedicalHistory(List<PastMedicalHistory> newEntries) {
    setState(() {
      widget.pastMedicalHistory.addAll(newEntries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 0.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Past Medical History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueGrey[800],
                        ),
                  ),
                  SizedBox(height: 12),
                  if (widget.pastMedicalHistory.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'No past medical history available.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: Colors.blueGrey[600],
                            ),
                      ),
                    )
                  else
                    Column(
                      children: widget.pastMedicalHistory.map((entry) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
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
                                      fontSize: 12,
                                      color: Colors.blueGrey[700],
                                    ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                entry.fieldValue.isNotEmpty
                                    ? entry.fieldValue
                                    : 'No additional information',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 12,
                                      color: Colors.blueGrey[500],
                                    ),
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.blueGrey[300],
                                thickness: 1,
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
                showAddMedicalHistoryDialog(
                  context,
                  widget.patient,
                  () {
                    // Refresh or update any necessary state here
                    _addMedicalHistory(widget.pastMedicalHistory);
                  },
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              mini: true,
              tooltip: 'Add Medical History',
            ),
          ),
        ],
      ),
    );
  }
}
