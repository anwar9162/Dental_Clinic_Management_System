import 'dart:convert';
import 'dart:typed_data';
import 'package:dental_management_main/models/patient_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import for MediaType
import 'package:mime/mime.dart'; // Import for MIME type lookup
import '../config/constants.dart';

class PatientApiService {
  final String baseUrl;

  PatientApiService() : baseUrl = Constants.baseUrl;

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => json as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<Map<String, dynamic>> getPatientById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/patients/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  Future<Map<String, dynamic>> getPatientByPhone(String phoneNumber) async {
    final response = await http
        .get(Uri.parse('$baseUrl/patients/phone-number/$phoneNumber'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patient by phone number');
    }
  }

  Future<void> createPatient(Map<String, dynamic> patientData) async {
    final url = Uri.parse('$baseUrl/patients');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(patientData),
      );

      if (response.statusCode == 201) {
        print('Patient added successfully');
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to add patient');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> updatePatient(
      String id, Map<String, dynamic> patient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/patients/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patient),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update patient');
    }
  }

  Future<void> deletePatient(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/patients/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete patient');
    }
  }

  Future<void> addDentalChartEntry(
      String id, Map<String, dynamic> entry) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/dental-chart'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entry),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add dental chart entry');
    }
  }

  Future<List<dynamic>> getDentalChart(String id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/patients/$id/dental-chart'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dental chart');
    }
  }

  Future<void> deleteDentalChartEntry(
      String id, String toothNumber, String entryId) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/patients/$id/dental-chart/$toothNumber/$entryId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete dental chart entry');
    }
  }

  Future<void> updateDentalChartEntry(String id, String toothNumber,
      String entryId, Map<String, dynamic> entry) async {
    final response = await http.put(
      Uri.parse('$baseUrl/patients/$id/dental-chart/$toothNumber/$entryId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entry),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update dental chart entry');
    }
  }

  Future<void> addPayment(String id, Map<String, dynamic> payment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/payments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add payment: ${response.body}');
    }
  }

  Future<void> updatePayment(
      String id, String paymentId, Map<String, dynamic> payment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/patients/$id/payments/$paymentId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update payment');
    }
  }

  Future<void> addProgressImages(
      String id, List<Uint8List> imageFiles, String dateCaptured) async {
    try {
      var uri = Uri.parse('$baseUrl/patients/$id/progress-images');
      var request = http.MultipartRequest('POST', uri);

      request.fields['dateCaptured'] = dateCaptured;

      for (var byteData in imageFiles) {
        var mimeType = lookupMimeType('', headerBytes: byteData) ??
            'image/jpeg'; // Get MIME type
        var fileExtension =
            mimeType.split('/').last; // Extract the file extension
        request.files.add(
          http.MultipartFile.fromBytes(
            'progressImages',
            byteData,
            filename:
                'image.$fileExtension', // Use the determined file extension
            contentType:
                MediaType('image', fileExtension), // Set the correct MIME type
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode != 201) {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to add progress images: $responseBody');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to add progress images');
    }
  }

  Future<void> addXrayImages(
      String id, List<Uint8List> imageFiles, String dateCaptured) async {
    try {
      var uri = Uri.parse('$baseUrl/patients/$id/xray-images');
      var request = http.MultipartRequest('POST', uri);

      request.fields['dateCaptured'] = dateCaptured;

      for (var byteData in imageFiles) {
        var mimeType = lookupMimeType('', headerBytes: byteData) ??
            'image/jpeg'; // Get MIME type
        var fileExtension =
            mimeType.split('/').last; // Extract the file extension
        request.files.add(
          http.MultipartFile.fromBytes(
            'xrayImages',
            byteData,
            filename:
                'image.$fileExtension', // Use the determined file extension
            contentType:
                MediaType('image', fileExtension), // Set the correct MIME type
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode != 201) {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to add x-ray images: $responseBody');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to add x-ray images');
    }
  }

  Future<List<Map<String, dynamic>>> getTodaysPatient() async {
    final response =
        await http.get(Uri.parse('$baseUrl/patients/today/patients'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => data as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load today\'s patients');
    }
  }

  // Add a visit record
  // Add a visit record
  Future<void> addVisitRecord(String id, Map<String, dynamic> visitData) async {
    // Log the request body for debugging purposes
    print('Request Body: ${jsonEncode(visitData)}');

    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/visit-records'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(visitData),
    );

    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      throw Exception(
          'Failed to add visit record: ${errorResponse['message']}');
    }
  }

  // Add past medical history
  Future<void> addPastMedicalHistory(
      String id, List<Map<String, dynamic>> entries) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/past-medical-history'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entries),
    );

    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      throw Exception(
          'Failed to add past medical history: ${errorResponse['message']}');
    }
  }

  // Add past dental history
  Future<void> addPastDentalHistory(
      String id, List<Map<String, dynamic>> entries) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/past-dental-history'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entries),
    );

    if (response.statusCode != 201) {
      final errorResponse = json.decode(response.body);
      throw Exception(
          'Failed to add past dental history: ${errorResponse['message']}');
    }
  }
}
