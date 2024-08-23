import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/patient_model.dart';

class VisitHistorySection extends StatelessWidget {
  final List<Visit>? visits;

  VisitHistorySection({this.visits});

  @override
  Widget build(BuildContext context) {
    final reversedVisits = (visits ?? []).reversed.toList();

    return Container(
      width: double.infinity, // Full width of the parent
      color: Colors.white, // White background for the section
      child: Card(
        elevation: 0, // Remove shadow for a flat design
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        color: Colors.white, // White background for the card
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for spacing
          child: reversedVisits.isEmpty
              ? _buildNoVisitHistory()
              : _buildVisitHistory(context, reversedVisits),
        ),
      ),
    );
  }

  Widget _buildNoVisitHistory() {
    return Center(
      child: Text(
        'No visit history available',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildVisitHistory(BuildContext context, List<Visit> visits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visit History',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800], // Professional color
              ),
        ),
        SizedBox(height: 12),
        ...visits.map((visit) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildVisitExpansionTile(visit),
            )),
      ],
    );
  }

  Widget _buildVisitExpansionTile(Visit visit) {
    return ExpansionTile(
      leading: Icon(Icons.history, color: Colors.blueGrey[600]),
      title: Text(
        'Date: ${DateFormat('yyyy-MM-dd').format(visit.date)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[700],
        ),
      ),
      subtitle: Text(
        visit.reason ?? 'No reason provided',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      children: [
        if (visit.chiefComplaint != null ||
            visit.historyOfPresentIllness != null)
          _buildCategoryRow(
            visit.chiefComplaint != null ? 'Chief Complaint' : null,
            visit.chiefComplaint,
            visit.historyOfPresentIllness != null
                ? 'History of Present Illness'
                : null,
            visit.historyOfPresentIllness,
          ),
        if (visit.physicalExamination != null ||
            visit.generalAppearance != null)
          _buildCategoryRow(
            visit.physicalExamination != null ? 'Physical Examination' : null,
            visit.physicalExamination,
            visit.generalAppearance != null ? 'General Appearance' : null,
            visit.generalAppearance,
          ),
        if (visit.extraOral != null || visit.internalOral != null)
          _buildCategoryRow(
            visit.extraOral != null ? 'Extra Oral Examination' : null,
            visit.extraOral,
            visit.internalOral != null ? 'Internal Oral Examination' : null,
            visit.internalOral,
          ),
        if (visit.diagnosis != null || visit.treatmentPlan != null)
          _buildCategoryRow(
            visit.diagnosis != null ? 'Diagnosis' : null,
            visit.diagnosis,
            visit.treatmentPlan != null ? 'Treatment Plan' : null,
            visit.treatmentPlan,
          ),
        if (visit.treatmentDone != null ||
            visit.progressNotes != null ||
            visit.payment != null)
          _buildCategoryRow(
            visit.treatmentDone != null ? 'Treatment Done' : null,
            visit.treatmentDone,
            visit.progressNotes != null ? 'Progress Notes' : null,
            visit.progressNotes,
            visit.payment != null ? 'Payment' : null,
            visit.payment,
          ),
      ],
    );
  }

  Widget _buildCategoryRow(
      String? title1, dynamic content1, String? title2, dynamic content2,
      [String? title3, dynamic content3]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: title1 != null
                ? _buildCategorySection(title1, content1)
                : Container(),
          ),
          SizedBox(width: 12),
          Expanded(
            child: title2 != null
                ? _buildCategorySection(title2, content2)
                : Container(),
          ),
          if (title3 != null) ...[
            SizedBox(width: 12),
            Expanded(
              child: _buildCategorySection(title3, content3),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, dynamic content) {
    if (content is List<ProgressNote>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(title),
          SizedBox(height: 8),
          ...content.map((item) => _buildProgressNoteRow(item)).toList(),
        ],
      );
    } else {
      final Map<String, String> contentMap = _convertToMap(content);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(title),
          SizedBox(height: 8),
          _buildCategoryDetails(contentMap),
        ],
      );
    }
  }

  Widget _buildCategoryHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 49, 190, 255),
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildCategoryDetails(Map<String, String> contentMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentMap.entries
          .map((entry) => _buildDetailRow(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: Colors.blueGrey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressNoteRow(ProgressNote note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.note,
                  style: TextStyle(color: Colors.blueGrey[600]),
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(note.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _convertToMap(dynamic content) {
    if (content is ChiefComplaint) {
      return {
        'Description': content.description,
        'Duration': content.duration,
        'Severity': content.severity,
      };
    } else if (content is HPI) {
      return {
        'Onset': content.onset,
        'Progression': content.progression,
        'Associated Symptoms': content.associatedSymptoms,
      };
    } else if (content is PhysicalExamination) {
      return {
        'Blood Pressure': content.bloodPressure,
        'Temperature': content.temperature,
        'Pulse': content.pulse,
        'Respiration Rate': content.respirationRate,
      };
    } else if (content is GeneralAppearance) {
      return {
        'Appearance': content.appearance,
        'Additional Notes': content.additionalNotes ?? 'N/A',
      };
    } else if (content is ExtraOral) {
      return {
        'Findings': content.findings,
      };
    } else if (content is InternalOral) {
      return {
        'Findings': content.findings,
      };
    } else if (content is Diagnosis) {
      return {
        'Condition': content.condition,
        'Details': content.details,
      };
    } else if (content is TreatmentPlan) {
      return {
        'Planned Treatments': content.plannedTreatments.join(', '),
        'Follow-Up Instructions': content.followUpInstructions ?? 'N/A',
      };
    } else if (content is TreatmentDone) {
      return {
        'Treatments': content.treatments.join(', '),
        'Completion Date': content.completionDate != null
            ? DateFormat('yyyy-MM-dd').format(content.completionDate!)
            : 'N/A',
      };
    } else if (content is Payment) {
      return {
        'Amount': content.amount.toString(),
        'Date': DateFormat('yyyy-MM-dd').format(content.date),
        'Status': content.status,
        'Reason': content.reason ?? 'N/A',
      };
    } else {
      return {};
    }
  }
}
