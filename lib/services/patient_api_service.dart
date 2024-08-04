import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class PatientApiService {
  final String baseUrl;

  PatientApiService()
      : baseUrl = Constants.baseUrl; // Use the base URL from Constants

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
        // Success
        print('Patient added successfully');
        return; // Indicate success
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to add patient');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(
          e.toString()); // Pass the error message through the exception
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
      throw Exception('Failed to add payment');
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
      String id, List<Map<String, dynamic>> images) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/progress-images'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'progressImages': images}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add progress images');
    }
  }

  Future<void> addXrayImages(
      String id, List<Map<String, dynamic>> images) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$id/xray-images'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'xrayImages': images}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add xray images');
    }
  }
}