import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/doctor_service.dart';
import '../theme/app_theme.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String _doctorName = 'Ramen';
  List<dynamic> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorName();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final appointments = await DoctorService().getDoctorAppointments();
      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDoctorName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'Ramen';
    setState(() {
      _doctorName = name.startsWith('Dr.') ? name : 'Dr. $name';
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -1),
            radius: 1.5,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildDailyForecastCard(),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 32),
                // Risk Alerts section removed
                const SizedBox(height: 120), // Bottom nav space
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.silverGradient.createShader(bounds),
              child: Text(
                _doctorName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'DIAPREDICT 2.0',
              style: TextStyle(
                color: AppColors.silver400,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDs7uc7i39HEzbZ6EB1PXNmNGq_x34PKacryJik0o6Wt2xNzQCtuTLKpwY9hZzNRlEjLd0LESpIY5zzfjzd_ezve1NzlHw-CaMy7GwRdBV1RemVI5ZHD9G9KJnbsH0oEr0Tl0507ikOrC3UJ0iziBvAGbeRCux05r68X-zAq1dvc0ZwEJ00gm-SWptglupVLdDHYA8SwRRFwbzDesPxwPYOrGw58P2-f3d4D-E3kGdzBmZTw_DE0NWtn1kJK5c86O6lJ8ifgOJDfC0',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecastCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TODAY',
                    style: TextStyle(
                      color: AppColors.silver500,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.silverGradient.createShader(bounds),
                    child: Text(
                      '${_appointments.length} Appointments',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_today_outlined, color: AppColors.silver200, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_appointments.isEmpty)
            const Text('No appointments for today', style: TextStyle(color: AppColors.silver400))
          else
            ..._appointments.take(3).map((appointment) {
              final startTime = appointment['start_time'] ?? '00:00';
              final patientName = appointment['patient_name'] ?? 'Patient';
              final notes = appointment['notes'] ?? 'General Checkup';
              
              // Simple time parsing for AM/PM
              final parts = startTime.split(':');
              int hour = int.parse(parts[0]);
              String period = hour >= 12 ? 'PM' : 'AM';
              if (hour > 12) hour -= 12;
              if (hour == 0) hour = 12;
              String formattedTime = '${hour.toString().padLeft(2, '0')}:${parts[1]}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildAppointmentItem(formattedTime, period, patientName, notes, false),
              );
            }).toList(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildAppointmentItem(String time, String period, String name, String type, bool last) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(color: AppColors.silver500, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                period,
                style: const TextStyle(color: AppColors.silver200, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 24, color: Colors.white.withOpacity(0.1)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  type,
                  style: const TextStyle(color: AppColors.silver500, fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.silver500, size: 18),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/manage-slots'),
            child: _buildGlassButton(Icons.event_available, 'Availability'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/manage-slots'),
            child: _buildGlassButton(Icons.list_alt, 'View Schedule'),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.silver200, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.silver200,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAlertsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'RISK ALERTS',
          style: TextStyle(
            color: AppColors.silver300,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '3 PRIORITY',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskAlertsList() {
    return Column(
      children: [
        _buildRiskAlertItem('David Sterling', '84/100', 'CRITICAL', Colors.redAccent),
        const SizedBox(height: 12),
        _buildRiskAlertItem('Elena Rossi', '72/100', 'HIGH RISK', Colors.amberAccent),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildRiskAlertItem(String name, String score, String level, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: accentColor.withOpacity(0.5), width: 4),
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
          right: BorderSide(color: Colors.white.withOpacity(0.1)),
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              level == 'CRITICAL' ? Icons.warning_amber_rounded : Icons.trending_up,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'SCORE: $score',
                  style: const TextStyle(
                    color: AppColors.silver500,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: accentColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
