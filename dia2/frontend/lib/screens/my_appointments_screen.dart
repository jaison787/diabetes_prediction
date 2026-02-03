import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_config.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  final String _baseUrl = ApiConfig.baseUrl;
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  String _role = 'USER';

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _role = prefs.getString('user_role') ?? 'USER';

    try {
      final endpoint = _role == 'DOCTOR' ? ApiConfig.doctorAppointments : ApiConfig.userAppointments;
      final response = await http.get(
        Uri.parse('${_baseUrl}$endpoint'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        setState(() {
          // Backend wraps appointments in 'data' object
          _appointments = responseData['data'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _appointments.isEmpty
          ? const Center(child: Text('No appointments found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appt = _appointments[index];
                final isDoctor = _role == 'DOCTOR';
                
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text(isDoctor ? 'Patient: ${appt['patient_name']}' : 'Doctor: ${appt['doctor_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${appt['slot_details']['date']}'),
                        Text('Time: ${appt['slot_details']['start_time']}'),
                        Text('Status: ${appt['status']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
