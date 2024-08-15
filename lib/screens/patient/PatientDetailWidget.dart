import 'package:flutter/material.dart';
import 'dart:io'; // Import this for File usage
import '../../models/patient_model.dart';
import '../../widgets/dental_chart.dart'; // Ensure you have the DentalChart widget
import '../../widgets/full_screen_image.dart'; // Import the full-screen image viewer
import '../../widgets/X-ray-and-progess-imageupload.dart'; // Import the dialog widget
import 'package:intl/intl.dart';

class PatientDetailWidget extends StatefulWidget {
  final Patient patient;

  PatientDetailWidget({required this.patient});

  @override
  _PatientDetailWidgetState createState() => _PatientDetailWidgetState();
}

class _PatientDetailWidgetState extends State<PatientDetailWidget> {
  late List<PatientImage> _progressImages;
  late List<PatientImage> _xrayImages;

  @override
  void initState() {
    super.initState();
    _updateImages();
  }

  @override
  void didUpdateWidget(PatientDetailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.patient != oldWidget.patient) {
      _updateImages();
    }
  }

  void _updateImages() {
    setState(() {
      _progressImages = widget.patient.progressImages ?? [];
      _xrayImages = widget.patient.xrayImages ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstVisitDate = widget.patient.firstVisitDate ?? DateTime.now();
    final daysSinceFirstVisit =
        DateTime.now().difference(firstVisitDate).inDays;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfoSection(widget.patient, daysSinceFirstVisit),
            SizedBox(height: 16),
            //   _buildDentalChartSection(widget.patient.dentalChart ?? []),
            SizedBox(height: 16),
            _buildProgressImagesSection(),
            SizedBox(height: 16),
            _buildXrayImagesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection(Patient patient, int daysSinceFirstVisit) {
    final DateFormat dateFormat =
        DateFormat('yyyy-MM-dd'); // Adjust the format as needed

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color.fromARGB(244, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${patient.firstName} ${patient.lastName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildInfoRow('Phone:', patient.phoneNumber!),
                  _buildInfoRow('Gender:', patient.gender!),
                  _buildInfoRow(
                    'DoB:',
                    patient.dateOfBirth != null
                        ? dateFormat.format(patient.dateOfBirth!)
                        : 'N/A',
                  ),
                  _buildInfoRow('Address', patient.Address!),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('assets/images/user_profile_image.jpg'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDentalChartSection(List<Tooth> dentalChart) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dental Chart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),
            DentalChart(dentalChart: dentalChart),
          ],
        ),
      ),
    );
  }

// Inside PatientDetailWidget
  Widget _buildProgressImagesSection() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress Images',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showAddImageDialog(
                      context,
                      widget.patient,
                      (newImage) {
                        setState(() {
                          _progressImages.add(newImage);
                        });
                      },
                      true, // Indicates progress image
                    );
                  },
                  child: Text(
                    'Add Image',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_progressImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.00,
                ),
                itemCount: _progressImages.length,
                itemBuilder: (context, index) {
                  final image = _progressImages[index];
                  return HoverImage(
                    imagePath:
                        'http://localhost:5000/images/${image.assetPath}', // Use URL
                    dateCaptured: image.dateCaptured,
                  );
                },
              )
            else
              Center(
                child: Text('No progress images available',
                    style: TextStyle(color: Colors.grey[600])),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildXrayImagesSection() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'X-Ray Images',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showAddImageDialog(
                      context,
                      widget.patient,
                      (newImage) {
                        setState(() {
                          _xrayImages.add(newImage);
                        });
                      },
                      false, // Indicates X-ray image
                    );
                  },
                  child: Text(
                    'Add Image',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_xrayImages.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.00,
                ),
                itemCount: _xrayImages.length,
                itemBuilder: (context, index) {
                  final image = _xrayImages[index];
                  return HoverImage(
                    imagePath:
                        'http://localhost:5000/images/${image.assetPath}', // Use URL
                    dateCaptured: image.dateCaptured,
                  );
                },
              )
            else
              Center(
                child: Text('No X-ray images available',
                    style: TextStyle(color: Colors.grey[600])),
              ),
          ],
        ),
      ),
    );
  }
}

class HoverImage extends StatefulWidget {
  final String imagePath; // This should be the URL of the image
  final DateTime dateCaptured;

  HoverImage({required this.imagePath, required this.dateCaptured});

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  FullScreenImage(imagePath: widget.imagePath),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isHovering ? 180 : 160,
              height: _isHovering ? 180 : 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image:
                      NetworkImage(widget.imagePath), // Updated to NetworkImage
                  fit: BoxFit.cover,
                ),
                boxShadow: _isHovering
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
              ),
            ),
            if (_isHovering)
              Positioned(
                top: -40,
                left: -40,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            widget.imagePath), // Updated to NetworkImage
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  DateFormat('yyyy-MMMM-dd').format(widget.dateCaptured),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
