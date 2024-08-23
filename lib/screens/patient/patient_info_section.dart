import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'build_info_row.dart'; // Import the new file
import '../../models/patient_model.dart';

class PatientInfoSection extends StatefulWidget {
  final Patient patient;

  PatientInfoSection({required this.patient});

  @override
  _PatientInfoSectionState createState() => _PatientInfoSectionState();
}

class _PatientInfoSectionState extends State<PatientInfoSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final cardStatus = widget.patient.cardStatus;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Colors.black.withOpacity(0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildHeader(),
              _isExpanded
                  ? _buildDetails(dateFormat, cardStatus)
                  : SizedBox.shrink(),
              _buildToggleExpandButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey[50],
      child: Row(
        children: [
          _buildProfileImage(),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildName(widget.patient.firstName, widget.patient.lastName),
                SizedBox(height: 8),
                Text(
                  widget.patient.phoneNumber ?? 'N/A',
                  style: TextStyle(fontSize: 10, color: Colors.blueGrey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(DateFormat dateFormat, CardStatus? cardStatus) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Gender:', widget.patient.gender ?? 'N/A'),
          _buildInfoRow(
            'DoB:',
            widget.patient.dateOfBirth != null
                ? dateFormat.format(widget.patient.dateOfBirth!)
                : 'N/A',
          ),
          _buildInfoRow('Address:', widget.patient.address ?? 'N/A'),
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
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/user_profile_image.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildName(String? firstName, String? lastName) {
    return Text(
      '${firstName ?? 'Unknown'} ${lastName ?? 'Patient'}',
      style: TextStyle(
        fontSize: 12,
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
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blueGrey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleExpandButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blueGrey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.blueGrey[600],
            ),
            SizedBox(width: 8),
            Text(
              _isExpanded ? 'Show Less' : 'Show More',
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
