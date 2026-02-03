import 'package:flutter/material.dart';
import '../services/doctor_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  late Future<Map<String, dynamic>> _slotsFuture;
  bool _isBooking = false;
  late Map<String, dynamic> _doctor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _slotsFuture = DoctorService().getSlots(_doctor['id']);
  }

  void _book(int slotId) async {
    setState(() => _isBooking = true);
    try {
      await DoctorService().bookAppointment(
        doctorId: _doctor['id'],
        timeSlotId: slotId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment Booked!')));
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book with ${_doctor['full_name']}')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue.withOpacity(0.1),
            child: Row(
              children: [
                CircleAvatar(radius: 30, child: Text(_doctor['full_name'][0])),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_doctor['full_name'] ?? 'Doctor', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(_doctor['specialization'] ?? ''),
                      Text('${_doctor['experience_years'] ?? 0} years of experience'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Available Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _slotsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

                // Response contains { doctor: {...}, time_slots: [...] }
                final data = snapshot.data!;
                final slots = data['time_slots'] as List<dynamic>? ?? [];
                
                if (slots.isEmpty) return const Center(child: Text('No slots available for this doctor.'));

                return ListView.builder(
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text('${slot['date']}'),
                      subtitle: Text('${slot['start_time']} - ${slot['end_time']}'),
                      trailing: _isBooking 
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _book(slot['id']),
                            child: const Text('Book Now'),
                          ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
