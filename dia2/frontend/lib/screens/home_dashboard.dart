import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../services/prediction_service.dart';
import '../theme/app_theme.dart';
import 'doctor_dashboard.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String _role = 'DOCTOR';
  String _name = 'Doctor';
  Map<String, dynamic>? _latestPrediction;
  bool _isHistoryLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadLatestPrediction();
  }

  void _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('user_role') ?? 'USER';
      _name = prefs.getString('user_name') ?? 'User';
    });
  }

  void _loadLatestPrediction() async {
    try {
      final history = await PredictionService().getXGBoostHistory();
      if (history.isNotEmpty) {
        setState(() {
          _latestPrediction = history.first;
          _isHistoryLoading = false;
        });
      } else {
        setState(() => _isHistoryLoading = false);
      }
    } catch (e) {
      setState(() => _isHistoryLoading = false);
    }
  }

  void _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to sign out?', style: TextStyle(color: AppColors.silver400)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.silver500)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('LOGOUT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService().logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _buildDashboardByRole(),
      ),
    );
  }

  Widget _buildDashboardByRole() {
    if (_role == 'ADMIN') return const Center(child: Text('Admin Dashboard'));
    if (_role == 'DOCTOR') return const DoctorDashboard();
    return _buildPatientDashboard();
  }

  Widget _buildPatientDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildRiskAssessmentCard(),
          const SizedBox(height: 48),
          _buildStatsSection(),
          const SizedBox(height: 48),
          _buildHealthActivitySection(),
          const SizedBox(height: 120), // Padding for bottom nav
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GOOD MORNING,',
              style: TextStyle(
                color: AppColors.silver500,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _name.split(' ')[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.silver500, size: 20),
            ),
            const SizedBox(width: 8),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2, ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.white24, Colors.white12],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDoiC-bPFms3pLg8hn98qQghmQXZZmv-5nsrSb8jlfbh_64FVw5WD34SAQHjmm0pzu3BpbqFgUcaJ-quGKp2qBmJxaL2LdZ4kIaTWODol91QCojkcbZciHVzDsu4u8y--S7lTFId3zCfgPBhaXBZs3fKtOoa0Jlz-i9QAViWrpdz197VpxMVO-Tsuj4QDUP4oLewUz1Xdo9AYClDzZaS4S_ZdhcmKp0WgLYAe6UgYSf6Bc1PwnxncGJ90xx2Jsi7Uq2fIRA1YBaxnk'),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.silver200,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskAssessmentCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.cardBorder),
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
                    'Risk Assessment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Next check in 14 days',
                    style: TextStyle(color: AppColors.silver400, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.info_outline, color: AppColors.silver300, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: _latestPrediction != null && _latestPrediction!['probability'] != null
                          ? (_latestPrediction!['probability'] as num).toDouble() / 100 
                          : 0.12,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => AppColors.silverGradient.createShader(bounds),
                        child: Text(
                          _latestPrediction != null && _latestPrediction!['probability'] != null
                              ? '${(_latestPrediction!['probability'] as num).toStringAsFixed(0)}%'
                              : '12%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        _latestPrediction != null && _latestPrediction!['risk_level'] != null
                            ? (_latestPrediction!['risk_level'] as String).toUpperCase()
                            : 'LOW RISK',
                        style: const TextStyle(
                          color: AppColors.silver400,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildScoreRow('HEALTH SCORE', 
                      _latestPrediction != null && _latestPrediction!['probability'] != null
                          ? '${(100 - (_latestPrediction!['probability'] as num)).toStringAsFixed(0)}/100'
                          : '88/100', 
                      Colors.white),
                  const SizedBox(height: 16),
                  _buildScoreRow('LAST UPDATE', 
                      _latestPrediction != null 
                          ? 'Today'
                          : '2 days ago', 
                      AppColors.silver400.withOpacity(0.4)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.silver500,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Stats',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See details', style: TextStyle(color: AppColors.silver500, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'GLUCOSE',
                _latestPrediction != null && _latestPrediction!['input_data'] != null
                    ? _latestPrediction!['input_data']['blood_glucose_level'].toString()
                    : '98',
                'mg/dL',
                Icons.water_drop,
                '-2% today',
                Icons.trending_down,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'HbA1c',
                _latestPrediction != null && _latestPrediction!['input_data'] != null
                    ? _latestPrediction!['input_data']['hba1c_level'].toString()
                    : '5.4',
                '%',
                Icons.science,
                'Normal Range',
                null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit, IconData icon, String trend, IconData? trendIcon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.silver200),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: AppColors.silver500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(color: AppColors.silver600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (trendIcon != null) ...[
                Icon(trendIcon, size: 12, color: Colors.greenAccent),
                const SizedBox(width: 4),
              ],
              Text(
                trend,
                style: TextStyle(
                  color: trendIcon != null ? Colors.white.withOpacity(0.4) : AppColors.silver600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthActivitySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Appointments',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View all', style: TextStyle(color: AppColors.silver500, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAppointmentCard('Dr. Adeel Maxwell', 'Endocrinologist', 'March 25th, 12:30 PM', 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=2670&auto=format&fit=crop'),
              const SizedBox(width: 16),
              _buildAppointmentCard('Dr. Sarah Chen', 'Nutritionist', 'April 2nd, 10:00 AM', 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=2574&auto=format&fit=crop'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(String name, String specialty, String time, String image) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorderBright, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(specialty, style: const TextStyle(color: AppColors.silver500, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.videocam_outlined, color: Colors.white, size: 16),
              ),
            ],
          ),
          const Divider(height: 32, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: AppColors.silver500),
                  const SizedBox(width: 8),
                  Text(time.split(',')[0], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: AppColors.silver500),
                  const SizedBox(width: 8),
                  Text(time.split(',')[1].trim(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('CONFIRM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('RESCHEDULE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
