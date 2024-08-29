import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/patient_model.dart';
import 'newvisitscreen.dart';

class VisitHistorySection extends StatelessWidget {
  final List<Visit>? visits;
  final Patient? patient;
  VisitHistorySection({this.visits, this.patient});

  @override
  Widget build(BuildContext context) {
    final reversedVisits = (visits ?? []).reversed.toList();

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Visit History',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14, // Reduced font size
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.blueGrey[600]),
                    onPressed: () {
                      NewVisitScreen.showAddVisitDialog(context, patient!);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8), // Reduced space
              if (reversedVisits.isEmpty)
                _buildNoVisitHistory(context)
              else
                ...reversedVisits.map((visit) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8.0), // Reduced space
                      child: _buildVisitExpansionTile(visit),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoVisitHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'No visit history available',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14, // Reduced font size
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16), // Space between message and button
      ],
    );
  }

  Widget _buildVisitExpansionTile(Visit visit) {
    return ExpansionTile(
      leading: Icon(Icons.history,
          color: Colors.blueGrey[600], size: 24), // Smaller icon
      title: Text(
        'Date: ${DateFormat('yyyy-MM-dd').format(visit.date)}',
        style: TextStyle(
          fontSize: 12, // Reduced font size
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[700],
        ),
      ),
      subtitle: Text(
        visit.reason ?? 'No reason provided',
        style: TextStyle(
            color: Colors.grey[600], fontSize: 12), // Reduced font size
      ),
      children: [
        if (visit.chiefComplaint != null ||
            visit.historyOfPresentIllness != null)
          _buildCategoryRow(
            visit.chiefComplaint != null
                ? 'Chief Complaint'
                : 'Chief Complaint (No data)',
            visit.chiefComplaint,
            visit.historyOfPresentIllness != null
                ? 'History of Present Illness'
                : 'History of Present Illness (No data)',
            visit.historyOfPresentIllness,
            visit.physicalExamination != null
                ? 'Physical Examination'
                : 'Physical Examination (No data)',
            visit.physicalExamination,
          ),
        if (visit.generalAppearance != null ||
            visit.extraOral != null ||
            visit.internalOral != null)
          _buildCategoryRow(
            visit.generalAppearance != null
                ? 'General Appearance'
                : 'General Appearance (No data)',
            visit.generalAppearance,
            visit.extraOral != null
                ? 'Extra Oral Examination'
                : 'Extra Oral Examination (No data)',
            visit.extraOral,
            visit.internalOral != null
                ? 'Internal Oral Examination'
                : 'Internal Oral Examination (No data)',
            visit.internalOral,
          ),
        if (visit.diagnosis != null ||
            visit.treatmentPlan != null ||
            visit.treatmentDone != null ||
            visit.progressNotes != null ||
            visit.payment != null)
          _buildCategoryRow(
            visit.diagnosis != null ? 'Diagnosis' : 'Diagnosis (No data)',
            visit.diagnosis,
            visit.treatmentPlan != null
                ? 'Treatment Plan'
                : 'Treatment Plan (No data)',
            visit.treatmentPlan,
            visit.treatmentDone != null
                ? 'Treatment Done'
                : 'Treatment Done (No data)',
            visit.treatmentDone,
          ),
        if (visit.progressNotes != null || visit.payment != null)
          _buildCategoryRow(
            visit.progressNotes != null
                ? 'Progress Notes'
                : 'Progress Notes (No data)',
            visit.progressNotes,
            visit.payment != null ? 'Payment' : 'Payment (No data)',
            visit.payment,
          ),
      ],
    );
  }

  Widget _buildCategoryRow(
      String title1, dynamic content1, String title2, dynamic content2,
      [String? title3, dynamic content3]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced space
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildCategorySection(title1, content1),
          ),
          SizedBox(width: 8), // Reduced space
          Expanded(
            child: _buildCategorySection(title2, content2),
          ),
          if (title3 != null) ...[
            SizedBox(width: 8), // Reduced space
            Expanded(
              child: _buildCategorySection(title3, content3),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, dynamic content) {
    if (content == null) {
      content = 'No data available'; // Default value for null content
    }

    if (content is List<ProgressNote>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(title),
          SizedBox(height: 4), // Reduced space
          ...content.map((item) => _buildProgressNoteRow(item)).toList(),
        ],
      );
    } else {
      final Map<String, String> contentMap = _convertToMap(content);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(title),
          SizedBox(height: 4), // Reduced space
          _buildCategoryDetails(contentMap),
        ],
      );
    }
  }

  Widget _buildCategoryHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 8.0), // Reduced padding
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 49, 190, 255),
          fontSize: 12, // Reduced font size
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
      padding: const EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 8.0), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[800],
                fontSize: 12, // Reduced font size
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 6), // Reduced space
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                  color: Colors.blueGrey[600],
                  fontSize: 12), // Reduced font size
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
      padding: const EdgeInsets.symmetric(
          vertical: 4.0, horizontal: 8.0), // Reduced padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.note,
                  style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontSize: 12), // Reduced font size
                ),
                SizedBox(height: 2), // Reduced space
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(note.createdAt),
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12), // Reduced font size
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
        'Description': content.description ?? 'No data available',
        'Duration': content.duration ?? 'No data available',
        'Severity': content.severity ?? 'No data available',
      };
    } else if (content is HPI) {
      return {
        'Onset': content.onset ?? 'No data available',
        'Progression': content.progression ?? 'No data available',
        'Associated Symptoms':
            content.associatedSymptoms ?? 'No data available',
      };
    } else if (content is PhysicalExamination) {
      return {
        'Blood Pressure': content.bloodPressure ?? 'No data available',
        'Temperature': content.temperature ?? 'No data available',
        'Pulse': content.pulse ?? 'No data available',
        'Respiration Rate': content.respirationRate ?? 'No data available',
      };
    } else if (content is GeneralAppearance) {
      return {
        'Appearance': content.appearance ?? 'No data available',
        'Additional Notes': content.additionalNotes ?? 'No data available',
      };
    } else if (content is ExtraOral) {
      return {
        'Findings': content.findings ?? 'No data available',
      };
    } else if (content is InternalOral) {
      return {
        'Findings': content.findings ?? 'No data available',
      };
    } else if (content is Diagnosis) {
      return {
        'Condition': content.condition ?? 'No data available',
        'Details': content.details ?? 'No data available',
      };
    } else if (content is TreatmentPlan) {
      return {
        'Planned Treatments': content.plannedTreatments.isNotEmpty
            ? content.plannedTreatments.join(', ')
            : 'No data available',
        'Follow-Up Instructions':
            content.followUpInstructions ?? 'No data available',
      };
    } else if (content is TreatmentDone) {
      return {
        'Treatments': content.treatments.isNotEmpty
            ? content.treatments.join(', ')
            : 'No data available',
        'Completion Date': content.completionDate != null
            ? DateFormat('yyyy-MM-dd').format(content.completionDate!)
            : 'No data available',
      };
    } else if (content is Payment) {
      return {
        'Amount': content.amount.toString(),
        'Date': DateFormat('yyyy-MM-dd').format(content.date),
        'Status': content.status,
        'Reason': content.reason ?? 'No data available',
      };
    } else {
      return {};
    }
  }
}
