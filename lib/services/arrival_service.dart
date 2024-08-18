// lib/services/arrival_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ArrivalService {
  final String apiUrl =
      'http://localhost:5000/api/arrivals'; // Update the URL if needed

  // Method to mark patient as arrived
  Future<void> markPatientAsArrived({
    required String patientId,
    required DateTime arrivalTime,
    String? notes,
    required String arrivalType,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'patientId': patientId,
        'arrivalTime': arrivalTime.toIso8601String(),
        'notes': notes,
        'arrivalType': arrivalType,
      }),
    );

    if (response.statusCode == 201) {
      // Successfully marked as arrived
      print('Patient marked as arrived');
    } else {
      // Handle the error
      throw Exception('Failed to mark patient as arrived: ${response.body}');
    }
  }

  // Optional: Method to get all arrivals
  Future<List<dynamic>> getAllArrivals() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Successfully fetched arrivals
      return jsonDecode(response.body);
    } else {
      // Handle the error
      throw Exception('Failed to load arrivals: ${response.body}');
    }
  }
}
