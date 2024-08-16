import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'build_info_row.dart'; // Import the new file
import '../../models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitHistorySection extends StatelessWidget {
  final List<Visit>? visits;

  VisitHistorySection({this.visits});

  @override
  Widget build(BuildContext context) {
    final reversedVisits = (visits ?? []).reversed.toList();

    if (reversedVisits.isEmpty) {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No visit history available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visit History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            ...reversedVisits.map((visit) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildVisitCard(visit),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitCard(Visit visit) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(visit.date)}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            SizedBox(height: 8),
            if (visit.reason != null) _buildDetailRow('Reason:', visit.reason!),
            if (visit.chiefComplaint != null)
              _buildDetailRow(
                  'Chief Complaint:', visit.chiefComplaint!.description),
            if (visit.historyOfPresentIllness != null)
              _buildDetailRow('HPI:', visit.historyOfPresentIllness!.onset),
            if (visit.physicalExamination != null)
              _buildDetailRow(
                  'Blood Pressure:', visit.physicalExamination.bloodPressure),
            if (visit.physicalExamination != null)
              _buildDetailRow(
                  'Temperature:', visit.physicalExamination.temperature),
            if (visit.generalAppearance != null)
              _buildDetailRow(
                  'General Appearance:', visit.generalAppearance.appearance),
            if (visit.internalOral != null)
              _buildDetailRow('Intra Oral', visit.internalOral.findings),
            if (visit.extraOral != null)
              _buildDetailRow('Extra Oral Findings', visit.extraOral!.findings),
            if (visit.progressNotes != null)
              ...visit.progressNotes!.map(
                (note) => _buildDetailRow(
                  'Progress Note:',
                  '${note.note} (${DateFormat('yyyy-MM-dd').format(note.createdAt)})',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(color: Colors.blueGrey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
