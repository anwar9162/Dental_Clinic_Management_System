import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorApiService {
  final String baseUrl;

  DoctorApiService() : baseUrl = 'http://localhost:5000/api';

  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl/doctors'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<Map<String, dynamic>> getDoctorById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/doctors/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load doctor');
    }
  }

  Future<void> createDoctor(Map<String, dynamic> doctorData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctors'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(doctorData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create doctor');
    }
  }

  Future<void> deleteDoctor(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/doctors/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctor');
    }
  }

  Future<void> updateDoctor(String id, Map<String, dynamic> doctorData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/doctors/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(doctorData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update doctor');
    }
  }
}
