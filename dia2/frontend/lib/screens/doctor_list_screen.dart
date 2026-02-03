import 'package:flutter/material.dart';
import '../services/doctor_service.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late Future<List<dynamic>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = DoctorService().getApprovedDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Doctors')),
      body: FutureBuilder<List<dynamic>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _doctorsFuture = DoctorService().getApprovedDoctors();
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          final doctors = snapshot.data!;
          if (doctors.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No approved doctors found.', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doc = doctors[index];
              // Backend fields from DoctorListSerializer
              final fullName = doc['full_name'] ?? 'Unknown Doctor';
              final specialization = doc['specialization'] ?? 'General';
              final experienceYears = doc['experience_years'] ?? 0;
              final city = doc['city'] ?? '';
              final consultationFee = doc['consultation_fee'] ?? '0.00';
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      fullName.isNotEmpty ? fullName[0].toUpperCase() : 'D',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(specialization),
                      Text('$experienceYears years exp${city.isNotEmpty ? " • $city" : ""}'),
                      Text('Fee: ₹$consultationFee', style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context, 
                      '/book-appointment', 
                      arguments: doc,
                    ),
                    child: const Text('Book'),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
