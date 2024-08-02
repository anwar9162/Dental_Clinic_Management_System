import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart'; // Adjust import path according to your file structure

Future<void> showAddImageDialog(
    BuildContext context, Function(PatientImage) onImageAdded) async {
  final _picker = ImagePicker();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _imagePath;

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

  return showDialog(
    context: context,
    builder: (context) {
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
                  try {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _imagePath = pickedFile.path;
                      (context as Element).markNeedsBuild(); // Trigger rebuild
                    }
                  } catch (e) {
                    await _showResultDialog(
                        'Error', 'Failed to pick image: $e');
                  }
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                    icon: Icon(Icons.calendar_today, color: Color(0xFF007BFF)),
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null &&
                          selectedDate != _selectedDate) {
                        _selectedDate = selectedDate;
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(_selectedDate!);
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFF007BFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color(0xFF007BFF), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
              if (_imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: kIsWeb
                      ? Image.network(_imagePath!,
                          height: 100, width: 100, fit: BoxFit.cover)
                      : Image.file(
                          File(_imagePath!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_selectedDate != null && _imagePath != null) {
                final newImage = PatientImage(
                  dateCaptured: _selectedDate!,
                  assetPath: _imagePath!,
                );
                onImageAdded(newImage);
                Navigator.of(context).pop();
                _showResultDialog('Success', 'Image added successfully!');
              } else {
                _showResultDialog(
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
}
