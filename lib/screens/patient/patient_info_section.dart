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
      elevation: 6, // Reduced elevation
      borderRadius: BorderRadius.circular(12), // Reduced border radius
      shadowColor: Colors.black.withOpacity(0.15), // Reduced shadow opacity
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.all(8), // Reduced padding
      color: Colors.blueGrey[50],
      child: Row(
        children: [
          _buildProfileImage(),
          SizedBox(width: 8), // Increased spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildName(widget.patient.firstName, widget.patient.lastName),
                SizedBox(height: 4), // Reduced spacing
                Text(
                  widget.patient.phoneNumber ?? 'N/A',
                  style: TextStyle(
                      fontSize: 14, // Slightly increased font size
                      color: Colors.blueGrey[800]),
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
      padding: const EdgeInsets.all(8.0), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildInfoRow('Gender:', widget.patient.gender ?? 'N/A'),
              ),
              SizedBox(width: 8), // Added spacing
              Expanded(
                flex: 1,
                child: _buildInfoRow(
                  'DoB:',
                  widget.patient.dateOfBirth != null
                      ? dateFormat.format(widget.patient.dateOfBirth!)
                      : 'N/A',
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Added spacing
          Row(
            children: [
              Expanded(
                flex: 1,
                child:
                    _buildInfoRow('Address:', widget.patient.address ?? 'N/A'),
              ),
              SizedBox(width: 8), // Added spacing
              Expanded(
                flex: 1,
                child: _buildInfoRow(
                  'Card Status:',
                  cardStatus?.isActive ?? false ? 'Active' : 'Inactive',
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // Added spacing
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildInfoRow(
                  'Expiration Date:',
                  cardStatus?.expirationDate != null
                      ? dateFormat.format(cardStatus!.expirationDate!)
                      : 'N/A',
                ),
              ),
              SizedBox(width: 8), // Added spacing
              Expanded(
                flex: 1,
                child: _buildInfoRow(
                  'Notes:',
                  cardStatus?.notes ?? 'None',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 60, // Reduced width
      height: 60, // Reduced height
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.blueAccent, width: 1), // Reduced border width
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Reduced shadow opacity
            blurRadius: 6, // Reduced blur radius
            offset: Offset(0, 2), // Reduced offset
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
        fontSize: 14, // Slightly increased font size
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
            fontSize: 14, // Reduced font size
          ),
        ),
        SizedBox(width: 8), // Added spacing
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.blueGrey[600],
              fontSize: 12, // Reduced font size
            ),
            overflow: TextOverflow.ellipsis, // Handle overflow
          ),
        ),
      ],
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
        padding: const EdgeInsets.all(8), // Reduced padding
        color: Colors.blueGrey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.blueGrey[600],
              size: 20, // Reduced icon size
            ),
            SizedBox(width: 4), // Reduced spacing
            Text(
              _isExpanded ? 'Show Less' : 'Show More',
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
                fontSize: 12, // Reduced font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
