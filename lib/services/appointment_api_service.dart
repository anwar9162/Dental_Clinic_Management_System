import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart'; // Import the Constants class

class AppointmentApiService {
  // Use Constants.baseUrl instead of passing baseUrl
  final String _baseUrl = Constants.baseUrl;

  // Helper method to handle HTTP responses
  Future<List<dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body);
      if (data is List) {
        return data;
      } else {
        return [data]; // Wrap single object in a list
      }
    } else {
      throw Exception('Failed to load data: ${response.reasonPhrase}');
    }
  }

  // Get all appointments
  Future<List<dynamic>> getAllAppointments() async {
    final response = await http.get(Uri.parse('$_baseUrl/appointments'));
    return _handleResponse(response);
  }

  // Get appointment by ID
  Future<Map<String, dynamic>> getAppointmentById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/appointments/$id'));
    return _handleResponse(response)
        .then((data) => data.isNotEmpty ? data.first : {});
  }

  // Create a new appointment
  Future<Map<String, dynamic>> createAppointment(
      Map<String, dynamic> appointmentData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(appointmentData),
    );
    return _handleResponse(response)
        .then((data) => data.isNotEmpty ? data.first : {});
  }

  // Update an appointment
  Future<Map<String, dynamic>> updateAppointment(
      String id, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/appointments/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateData),
    );
    return _handleResponse(response)
        .then((data) => data.isNotEmpty ? data.first : {});
  }

  // Delete an appointment
  Future<void> deleteAppointment(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/appointments/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment: ${response.reasonPhrase}');
    }
  }

  // Get today's appointments
  Future<List<dynamic>> getTodaysAppointments() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/appointments/today/appointments'));
    return _handleResponse(response);
  }

  // Get arrived patients
  Future<List<dynamic>> getArrivedPatients() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/appointments/today/arrived'));
    return _handleResponse(response);
  }

  // Get visit history for a patient
  Future<List<dynamic>> getVisitHistory(String patientId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/appointments/history/$patientId'));
    return _handleResponse(response);
  }
}
