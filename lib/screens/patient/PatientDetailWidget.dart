import 'package:flutter/material.dart';
import 'patient_info_section.dart';
import 'progress_images_section.dart';
import 'xray_images_section.dart';
import 'visit_history_section.dart';
import '../../models/patient_model.dart';
import '../../widgets/X-ray-and-progess-imageupload.dart'; // Import the dialog widget

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

  void _showAddImageDialog(bool isProgressImage) {
    showAddImageDialog(
      context,
      widget.patient,
      (newImage) {
        setState(() {
          if (isProgressImage) {
            _progressImages.add(newImage);
          } else {
            _xrayImages.add(newImage);
          }
        });
      },
      isProgressImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatientInfoSection(patient: widget.patient),
            SizedBox(height: 16),
            VisitHistorySection(visits: widget.patient.visitHistory),
            SizedBox(height: 16),
            ProgressImagesSection(
              progressImages: _progressImages,
              onAddImage: () => _showAddImageDialog(true),
            ),
            SizedBox(height: 16),
            XrayImagesSection(
              xrayImages: _xrayImages,
              onAddImage: () => _showAddImageDialog(false),
            ),
          ],
        ),
      ),
    );
  }
}
