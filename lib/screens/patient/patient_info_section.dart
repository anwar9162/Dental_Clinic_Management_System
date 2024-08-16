import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'build_info_row.dart'; // Import the new file
import '../../models/patient_model.dart';

class PatientInfoSection extends StatelessWidget {
  final Patient patient;

  PatientInfoSection({required this.patient});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final cardStatus = patient.cardStatus;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileImage(),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildName(patient.firstName, patient.lastName),
                  SizedBox(height: 16),
                  _buildInfoRow('Phone:', patient.phoneNumber),
                  _buildInfoRow('Gender:', patient.gender ?? 'N/A'),
                  _buildInfoRow(
                    'DoB:',
                    patient.dateOfBirth != null
                        ? dateFormat.format(patient.dateOfBirth!)
                        : 'N/A',
                  ),
                  _buildInfoRow('Address:', patient.address ?? 'N/A'),
                  _buildInfoRow(
                    'Card Status:',
                    cardStatus?.isActive ?? false ? 'Active' : 'Inactive',
                  ),
                  _buildInfoRow(
                    'Expiration Date:',
                    cardStatus?.expirationDate != null
                        ? dateFormat.format(cardStatus!.expirationDate!)
                        : 'N/A',
                  ),
                  _buildInfoRow(
                    'Notes:',
                    cardStatus?.notes ?? 'None',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: 120,
        height: 120,
        color: Colors.grey[200],
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset('assets/images/user_profile_image.jpg'),
        ),
      ),
    );
  }

  Widget _buildName(String? firstName, String? lastName) {
    return Text(
      '${firstName ?? 'Unknown'} ${lastName ?? 'Patient'}',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
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
