import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_config.dart';

class ManageSlotsScreen extends StatefulWidget {
  const ManageSlotsScreen({super.key});

  @override
  State<ManageSlotsScreen> createState() => _ManageSlotsScreenState();
}

class _ManageSlotsScreenState extends State<ManageSlotsScreen> {
  final String _baseUrl = ApiConfig.baseUrl;
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  
  List<dynamic> _slots = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  void _fetchSlots() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}${ApiConfig.doctorTimeSlots}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        setState(() => _slots = responseData['data'] ?? []);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _addSlot() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}${ApiConfig.doctorTimeSlots}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'date': _dateController.text,
          'start_time': _startTimeController.text,
          'end_time': _endTimeController.text,
        }),
      );
      
      if (response.statusCode == 201) {
        _fetchSlots();
        _dateController.clear();
        _startTimeController.clear();
        _endTimeController.clear();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage My Slots')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _startTimeController, decoration: const InputDecoration(labelText: 'Start (HH:MM)'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _endTimeController, decoration: const InputDecoration(labelText: 'End (HH:MM)'))),
                  ],
                ),
                const SizedBox(height: 10),
                _isLoading 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _addSlot, child: const Text('Add Slot')),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _slots.length,
              itemBuilder: (context, index) {
                final slot = _slots[index];
                return ListTile(
                  leading: const Icon(Icons.timer),
                  title: Text(slot['date']),
                  subtitle: Text('${slot['start_time']} - ${slot['end_time']}'),
                  trailing: slot['status'] == 'BOOKED' 
                    ? const Chip(label: Text('Booked'), backgroundColor: Colors.redAccent)
                    : const Chip(label: Text('Available'), backgroundColor: Colors.greenAccent),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
