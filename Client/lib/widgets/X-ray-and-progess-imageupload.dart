import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html; // For web support
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart'; // Adjust import path according to your file structure
import '../services/patient_api_service.dart'; // Import the PatientApiService

Future<void> showAddImageDialog(BuildContext context, Patient patient,
    Function(PatientImage) onImageAdded, bool isProgressImage) async {
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  Uint8List? _imageFile;
  String? _fileName;

  final apiService = PatientApiService(); // Instantiate the API service

  Future<void> _showResultDialog(String title, String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web-specific file picker
      final uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final reader = html.FileReader();
          _fileName = files[0].name;
          reader.readAsArrayBuffer(files[0]);
          reader.onLoadEnd.listen((e) {
            _imageFile = reader.result as Uint8List;
            // Force UI update
            (context as Element).markNeedsBuild();
          });
        }
      });
      uploadInput.click();
    }
  }

  Future<void> _uploadImage(
      Uint8List image, String fileName, DateTime dateCaptured) async {
    try {
      if (isProgressImage) {
        await apiService.addProgressImages(patient.id!, [image],
            DateFormat('yyyy-MM-dd').format(dateCaptured));
      } else {
        await apiService.addXrayImages(patient.id!, [image],
            DateFormat('yyyy-MM-dd').format(dateCaptured));
      }
      final newImage = PatientImage(
        dateCaptured: dateCaptured,
        assetPath: 'web image',
      );
      onImageAdded(newImage);
      Navigator.of(context).pop();
      await _showResultDialog('Success', 'Image added successfully!');
    } catch (e) {
      await _showResultDialog('Error', 'Failed to add image: $e');
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text(
              'Add Image',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Picker
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _pickImage();
                      setState(() {});
                    },
                    icon: Icon(Icons.image),
                    label: Text('Select Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF007BFF), // Background color (soft blue)
                      foregroundColor: Colors.white, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      elevation: 5,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Date Picker
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: Color(0xFF007BFF)),
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null &&
                              selectedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = selectedDate;
                              _dateController.text = DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate!);
                            });
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF007BFF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0xFF007BFF), width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  if (_imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Image.memory(_imageFile!,
                          height: 100, width: 100, fit: BoxFit.cover),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (_selectedDate != null && _imageFile != null) {
                    await _uploadImage(_imageFile!, _fileName!, _selectedDate!);
                  } else {
                    await _showResultDialog(
                        'Error', 'Please select both an image and a date.');
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Color(0xFF007BFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
