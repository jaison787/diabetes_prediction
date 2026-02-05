import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/doctor_service.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();
  final ScrollController _calendarScrollController = ScrollController();
  final List<String> _weekDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDate());
  }

  void _scrollToSelectedDate() {
    if (_calendarScrollController.hasClients) {
      final index = _selectedDate.day - 1;
      _calendarScrollController.jumpTo(index * 72.0);
    }
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

  List<DateTime> get _visibleDates {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => DateTime(now.year, now.month, index + 1));
  }

  List<dynamic> get _filteredAppointments {
    // Filter to show only appointments for the selected date
    final selectedStr = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    
    return _appointments.where((apt) {
      final slot = apt['slot_details'] ?? {};
      final rawDate = (apt['date'] ?? slot['date'])?.toString() ?? '';
      
      // Clean the date (handle ISO format like 2026-02-05T00:00:00Z)
      final cleanDate = rawDate.contains('T') ? rawDate.split('T')[0] : rawDate.split(' ')[0];
      
      return cleanDate == selectedStr;
    }).toList();
  }

  String _getAvailableDates() {
    if (_appointments.isEmpty) return "None";
    final dates = _appointments.map((a) {
      final d = a['date'] ?? (a['slot_details'] ?? {})['date'] ?? 'No Date';
      return d.toString().split('T')[0].split(' ')[0];
    }).toSet().toList();
    return dates.join(", ");
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
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildDatePicker(),
                      const SizedBox(height: 32),
                      if (_isLoading)
                        const Center(child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: CircularProgressIndicator(color: Colors.white),
                        ))
                      else if (_filteredAppointments.isEmpty)
                        Center(child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              Icon(Icons.event_busy_rounded, size: 48, color: Colors.white.withOpacity(0.1)),
                              const SizedBox(height: 12),
                              Text(
                                'No appointments for ${DateFormat('MMM d').format(_selectedDate)}',
                                style: const TextStyle(color: AppColors.silver500),
                              ),
                            ],
                          ),
                        ))
                      else
                        ..._filteredAppointments.map((apt) => _buildPatientCard(apt)),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          ),
          Row(
            children: [
              _buildHeaderButton(Icons.search),
              const SizedBox(width: 12),
              _buildHeaderButton(Icons.calendar_today),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year && 
                   _selectedDate.month == now.month && 
                   _selectedDate.day == now.day;
    
    final headerTitle = isToday ? "Today's\nSchedule" : "Schedule";
    final dateText = DateFormat('EEEE, MMMM d').format(_selectedDate);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => AppColors.silverGradient.createShader(bounds),
          child: Text(
            headerTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          dateText,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _calendarScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _visibleDates.length,
        itemBuilder: (context, index) {
          final date = _visibleDates[index];
          final now = DateTime.now();
          final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
          final isSelected = date.year == _selectedDate.year && 
                            date.month == _selectedDate.month && 
                            date.day == _selectedDate.day;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withOpacity(0.15) 
                    : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.3) 
                      : isToday 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekDays[date.weekday % 7],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.silver500,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGroupedAppointments() {
    List<Widget> items = [];
    final filtered = _filteredAppointments;
    
    // Debug: Show count
    items.add(
      Text(
        'Showing ${filtered.length} appointments',
        style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
      ),
    );
    items.add(const SizedBox(height: 16));
    
    // Show all appointments
    for (var apt in filtered) {
      try {
        items.add(_buildPatientCard(apt));
      } catch (e) {
        items.add(
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.red.withOpacity(0.2),
            child: Text('Error rendering card: $e', style: const TextStyle(color: Colors.red)),
          ),
        );
      }
    }

    return items;
  }

  Widget _buildMiniCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT DATE',
          style: TextStyle(
            color: AppColors.silver500,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 85,
          child: ListView.separated(
            controller: _calendarScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _visibleDates.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final date = _visibleDates[index];
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final itemDate = DateTime(date.year, date.month, date.day);
              
              bool isActive = _selectedDate.day == date.day && 
                             _selectedDate.month == date.month && 
                             _selectedDate.year == date.year;
              
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? Colors.white.withOpacity(0.12) 
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive 
                          ? Colors.white.withOpacity(0.3) 
                          : Colors.white.withOpacity(0.05),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekDays[date.weekday % 7],
                        style: TextStyle(
                          color: isActive ? Colors.white : AppColors.silver400,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: AppColors.silver200, size: 20),
    );
  }

  Widget _buildPatientCard(dynamic apt) {
    // Attempt to get data from root or slot_details
    final slot = apt['slot_details'] ?? {};
    final startTime = apt['start_time'] ?? slot['start_time'] ?? '09:00';
    final endTime = apt['end_time'] ?? slot['end_time'] ?? '10:00';
    
    // Safe name mapping - handle case where patient is an ID (int) not an object
    String patientName = 'Patient';
    final patientField = apt['patient'];
    final userField = apt['user'];
    
    if (apt['patient_name'] != null) {
      patientName = apt['patient_name'].toString();
    } else if (apt['patient_full_name'] != null) {
      patientName = apt['patient_full_name'].toString();
    } else if (apt['user_full_name'] != null) {
      patientName = apt['user_full_name'].toString();
    } else if (patientField is Map) {
      patientName = patientField['full_name'] ?? 
                   patientField['name'] ?? 
                   (patientField['first_name'] != null ? "${patientField['first_name']} ${patientField['last_name'] ?? ''}" : 'Patient');
    } else if (userField is Map) {
      patientName = userField['full_name'] ?? 
                   userField['name'] ?? 
                   (userField['first_name'] != null ? "${userField['first_name']} ${userField['last_name'] ?? ''}" : 'Patient');
    } else if (patientField is String) {
      patientName = patientField;
    }
                       
    final riskLevel = (apt['risk_level'] ?? 'Low Risk').toString().toUpperCase();
    final riskScore = apt['risk_score'] ?? '0.00';
    final description = apt['notes'] ?? slot['label'] ?? 'Consultation';
    
    // Time formatting helper - with safety
    String formatTime(String? timeStr) {
      try {
        if (timeStr == null || timeStr.isEmpty) return '09:00 AM';
        // Extract just the HH:MM part if it's a full timestamp
        String cleanTime = timeStr;
        if (timeStr.contains('T')) {
          cleanTime = timeStr.split('T')[1].substring(0, 5);
        } else if (timeStr.contains(' ')) {
          cleanTime = timeStr.split(' ')[0];
        }
        final parts = cleanTime.split(':');
        int h = int.tryParse(parts[0]) ?? 9;
        final m = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
        final p = h >= 12 ? 'PM' : 'AM';
        h = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        return '${h.toString().padLeft(2, '0')}:$m $p';
      } catch (e) {
        return '09:00 AM';
      }
    }

    final displayTimeRange = "${formatTime(startTime)} - ${formatTime(endTime)}";
    final fTime = formatTime(startTime).split(' ')[0];
    final period = formatTime(startTime).split(' ')[1];

    Color riskColor;
    if (riskLevel.contains('HIGH')) {
      riskColor = Colors.redAccent;
    } else if (riskLevel.contains('MODERATE')) {
      riskColor = Colors.amberAccent;
    } else {
      riskColor = Colors.greenAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // Time box
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: AppColors.silverGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fTime,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Patient info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        patientName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: riskColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: riskColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: riskColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        riskLevel,
                        style: TextStyle(
                          color: riskColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Score: $riskScore',
                      style: const TextStyle(
                        color: AppColors.silver500,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  displayTimeRange,
                  style: const TextStyle(
                    color: AppColors.silver500,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.silver400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
