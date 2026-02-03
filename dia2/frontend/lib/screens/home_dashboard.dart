import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String _role = 'USER';
  String _name = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('user_role') ?? 'USER';
      _name = prefs.getString('user_name') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DiaPredict Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: _buildDashboardByRole(),
      floatingActionButton: _role == 'USER' 
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/predict'),
            label: const Text('Check Risk'),
            icon: const Icon(Icons.analytics),
          )
        : null,
    );
  }

  Widget _buildDashboardByRole() {
    if (_role == 'ADMIN') return _buildAdminDashboard();
    if (_role == 'DOCTOR') return _buildDoctorDashboard();
    return _buildPatientDashboard();
  }

  Widget _buildPatientDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, $_name!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildCard(
            'My Prediction History',
            'View your past diabetes risk assessments.',
            Icons.history,
            () => Navigator.pushNamed(context, '/prediction-history'),
          ),
          const SizedBox(height: 15),
          _buildCard(
            'My Appointments',
            'Check your upcoming visits with doctors.',
            Icons.event,
            () => Navigator.pushNamed(context, '/my-appointments'),
          ),
          const SizedBox(height: 15),
          _buildCard(
            'Nearby Doctors',
            'Find specialists and book consultations.',
            Icons.local_hospital,
            () => Navigator.pushNamed(context, '/doctor-list'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Doctor Portal: $_name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildCard(
            'Manage Availability',
            'Add or edit your consultation time slots.',
            Icons.access_time,
            () => Navigator.pushNamed(context, '/manage-slots'),
          ),
          const SizedBox(height: 15),
          _buildCard(
            'View Patient Bookings',
            'See appointments requested by users.',
            Icons.book_online,
            () => Navigator.pushNamed(context, '/my-appointments'),
          ),
          const SizedBox(height: 15),
          _buildCard(
            'User Feedback',
            'Read ratings and comments from patients.',
            Icons.feedback,
            () => Navigator.pushNamed(context, '/view-feedback'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Admin Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildCard(
            'Approve Doctors',
            'Review and approve new doctor registrations.',
            Icons.verified_user,
            () => Navigator.pushNamed(context, '/admin/approve-doctors'),
          ),
          const SizedBox(height: 15),
          _buildCard(
            'System Monitoring',
            'Overview of users, doctors, and bookings.',
            Icons.dashboard,
            () => {},
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
