import 'package:flutter/material.dart';
import 'patient_info_section.dart';
import 'progress_images_section.dart';
import 'xray_images_section.dart';
import 'visit_history_section.dart';
import 'past_medical_history_section.dart'; // Import the new section
import 'past_dental_history_section.dart'; // Import the new section
import '../../models/patient_model.dart';
import '../../../models/basic_patient_info_model.dart'; // Update import path
import '../../widgets/X-ray-and-progess-imageupload.dart'; // Import the dialog widget
import '../../services/patient_api_service.dart';

class PatientDetailWidget extends StatefulWidget {
  final PatientBasicInfo patientBasicInfo;

  PatientDetailWidget({required this.patientBasicInfo, Key? key})
      : super(key: key);

  @override
  _PatientDetailWidgetState createState() => _PatientDetailWidgetState();
}

class _PatientDetailWidgetState extends State<PatientDetailWidget> {
  late Future<Map<String, dynamic>> _patientFuture;
  late List<PatientImage> _progressImages;
  late List<PatientImage> _xrayImages;

  @override
  void didUpdateWidget(covariant PatientDetailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.patientBasicInfo.id != oldWidget.patientBasicInfo.id) {
      _patientFuture = _fetchPatientDetails();
    }
  }

  @override
  void initState() {
    super.initState();
    _patientFuture = _fetchPatientDetails();
  }

  Future<Map<String, dynamic>> _fetchPatientDetails() async {
    final apiService = PatientApiService();
    final patient = await apiService.getPatientById(widget.patientBasicInfo.id);
    return patient;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _patientFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        final patientData = snapshot.data!;
        final patient = Patient.fromJson(patientData);

        _progressImages = patient.progressImages ?? [];
        _xrayImages = patient.xrayImages ?? [];

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PatientInfoSection(patient: patient),
                SizedBox(height: 16),
                VisitHistorySection(
                  visits: patient.visitHistory ?? [],
                  patient: patient,
                ),
                SizedBox(height: 16),
                PastMedicalHistorySection(
                  pastMedicalHistory: patient.pastMedicalHistory ?? [],
                  patient: patient,
                ),
                SizedBox(height: 16),
                PastDentalHistorySection(
                  pastDentalHistory: patient.pastDentalHistory ?? [],
                  patient: patient,
                ),
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
      },
    );
  }

  void _showAddImageDialog(bool isProgressImage) {
    showAddImageDialog(
      context,
      Patient.fromJson({}), // Pass an empty Patient object or update as needed
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
}
