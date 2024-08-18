import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment_model.dart';
import '../config/constants.dart';

class AppointmentService {
  final String baseUrl;

  // Constructor using base URL from Constants
  AppointmentService() : baseUrl = Constants.baseUrl;

  Future<List<Appointment>> getAllAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointments'));

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      List jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((data) {
        print('Parsed Data: $data');
        return Appointment.fromJson(data as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<Appointment> getAppointmentById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/appointments/$id'));

    if (response.statusCode == 200) {
      return Appointment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load appointment');
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    // Prepare the custom JSON body for the API request
    final Map<String, dynamic> body = {
      'patient': appointment.patient,
      'doctor': appointment.doctor,
      'date': appointment.date.toIso8601String(),
      'appointmentReason': appointment.appointmentReason,
      'notes': appointment.notes?.map((note) => note.toJson()).toList() ?? [],
    };

    print('Creating appointment with data: $body'); // Print the custom body

    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body), // Use the custom body here
    );

    if (response.statusCode == 201) {
      return Appointment.fromJson(json.decode(response.body));
    } else {
      print('Failed to create appointment: ${response.body}');
      throw Exception('Failed to create appointment');
    }
  }

  Future<void> updateAppointment(
      String id, String status, List<Note> newNotes) async {
    print('Updating appointment with ID: $id');
    print('Base URL: $baseUrl');
    print('Request Body: ${json.encode({
          'status': status,
          'newNotes': newNotes.map((note) => note.toJson()).toList(),
        })}');

    final response = await http.put(
      Uri.parse('$baseUrl/appointments/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'status': status,
        'newNotes': newNotes.map((note) => note.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      print('Appointment updated successfully');
    } else {
      print('Failed to update appointment: ${response.body}');
      final errorResponse = json.decode(response.body);
      throw Exception(
          'Failed to update appointment: ${errorResponse['message']}');
    }
  }

  Future<void> deleteAppointment(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/appointments/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment');
    }
  }

  Future<List<Appointment>> getTodaysAppointments() async {
    final response =
        await http.get(Uri.parse('$baseUrl/appointments/today/appointments'));

    // Log the raw response body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Appointment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load today\'s appointments');
    }
  }

  Future<List<Appointment>> getVisitHistory(String patientId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/appointments/history/$patientId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Appointment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load visit history');
    }
  }
}
