import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class DoctorService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<dynamic>> getApprovedDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${_baseUrl}${ApiConfig.approvedDoctors}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Backend returns list directly for ListAPIView
      return responseData is List ? responseData : (responseData['results'] ?? []);
    } else {
      throw Exception(responseData['message'] ?? 'Failed to fetch doctors');
    }
  }

  Future<Map<String, dynamic>> getSlots(int doctorId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${_baseUrl}${ApiConfig.doctorSlots(doctorId)}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success'] == true) {
      // Returns {doctor: {...}, time_slots: [...]}
      return responseData['data'];
    } else {
      throw Exception(responseData['message'] ?? 'Failed to fetch slots');
    }
  }

  Future<void> bookAppointment({
    required int doctorId,
    required int timeSlotId,
    String? notes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('${_baseUrl}${ApiConfig.userAppointments}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'doctor': doctorId,
        'time_slot': timeSlotId,
        if (notes != null) 'notes': notes,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode != 201 || responseData['success'] != true) {
      throw Exception(responseData['message'] ?? 'Booking failed');
    }
  }
  Future<List<dynamic>> getDoctorAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${_baseUrl}${ApiConfig.doctorAppointments}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Backend returns list directly or in 'results'
      return responseData is List ? responseData : (responseData['results'] ?? responseData['data'] ?? []);
    } else {
      throw Exception(responseData['message'] ?? 'Failed to fetch appointments');
    }
  }

  /// Fetch the logged-in doctor's profile
  Future<Map<String, dynamic>> getDoctorProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${_baseUrl}${ApiConfig.doctorProfile}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Handle both wrapped and direct response
      if (responseData is Map<String, dynamic>) {
        return responseData['data'] ?? responseData;
      }
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Failed to fetch doctor profile');
    }
  }
}
