import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../services/doctor_service.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = true;
  String? _error;
  bool _locationEnabled = false;
  String _sortMode = 'distance'; // 'distance' or 'name'

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get doctors from API
      final doctors = await DoctorService().getApprovedDoctors();
      
      // Try to get user location
      Map<String, double>? userLocation = await _locationService.getSavedLocation();
      
      if (userLocation == null) {
        final position = await _locationService.getCurrentLocation();
        if (position != null) {
          userLocation = {'lat': position.latitude, 'lon': position.longitude};
        }
      }

      if (userLocation != null) {
        // Sort by distance
        _doctors = _locationService.sortDoctorsByDistance(doctors, userLocation);
        _locationEnabled = true;
      } else {
        // No location, just convert to list
        _doctors = doctors.map((d) => {
          ...Map<String, dynamic>.from(d),
          'distance': null,
          'distance_display': 'Location unavailable',
        }).toList();
        _locationEnabled = false;
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleSortMode() {
    setState(() {
      if (_sortMode == 'distance') {
        _sortMode = 'name';
        _doctors.sort((a, b) {
          final nameA = a['full_name']?.toString() ?? '';
          final nameB = b['full_name']?.toString() ?? '';
          return nameA.compareTo(nameB);
        });
      } else {
        _sortMode = 'distance';
        _doctors.sort((a, b) {
          final distA = a['distance'] as double?;
          final distB = b['distance'] as double?;
          if (distA == null && distB == null) return 0;
          if (distA == null) return 1;
          if (distB == null) return -1;
          return distA.compareTo(distB);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1),
                radius: 1.5,
                colors: [
                  Color(0xFF2A2A2A),
                  Color(0xFF0A0A0A),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.white70))
              : _error != null 
                ? _buildErrorState(_error!)
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildHeader(_doctors.length),
                      if (_doctors.isEmpty)
                        SliverFillRemaining(
                          child: _buildEmptyState(),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final doc = _doctors[index];
                                return _buildDoctorCard(context, doc, index);
                              },
                              childCount: _doctors.length,
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
          ),
          
          // Back Button
          Positioned(
            top: 50,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFF94A3B8)],
                    ).createShader(bounds),
                    child: Text(
                      'Available Specialists',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sort and Location Info
            Row(
              children: [
                // Location Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _locationEnabled 
                        ? Colors.greenAccent.withOpacity(0.1) 
                        : Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _locationEnabled 
                          ? Colors.greenAccent.withOpacity(0.3) 
                          : Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _locationEnabled ? Icons.location_on : Icons.location_off,
                        size: 14,
                        color: _locationEnabled ? Colors.greenAccent : Colors.amber,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _locationEnabled ? 'Near You' : 'Location Off',
                        style: TextStyle(
                          color: _locationEnabled ? Colors.greenAccent : Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Sort Toggle
                GestureDetector(
                  onTap: _toggleSortMode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _sortMode == 'distance' ? Icons.near_me : Icons.sort_by_alpha,
                          size: 14,
                          color: AppColors.silver400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _sortMode == 'distance' ? 'By Distance' : 'By Name',
                          style: const TextStyle(
                            color: AppColors.silver400,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Refresh Location
                GestureDetector(
                  onTap: _loadDoctors,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(Icons.refresh, size: 16, color: AppColors.silver400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doc, int index) {
    final String fullName = doc['full_name'] ?? 'Dr. Unknown';
    final String specialization = doc['qualification'] ?? doc['specialization'] ?? 'Specialist';
    final String city = doc['city'] ?? '';
    final String distanceDisplay = doc['distance_display'] ?? '';
    final double? distance = doc['distance'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context, 
          '/book-appointment', 
          arguments: doc,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Distance Badge
                        Row(
                          children: [
                            Icon(
                              distance != null ? Icons.near_me : Icons.location_off,
                              size: 14, 
                              color: distance != null 
                                  ? Colors.greenAccent.withOpacity(0.8)
                                  : const Color(0xFFCBD5E1).withOpacity(0.5),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              distance != null ? distanceDisplay : city.isNotEmpty ? city : 'Location unknown',
                              style: TextStyle(
                                color: distance != null 
                                    ? Colors.greenAccent.withOpacity(0.9)
                                    : const Color(0xFFCBD5E1),
                                fontSize: 12,
                                fontWeight: distance != null ? FontWeight.w600 : FontWeight.normal,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (distance != null && city.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                '• $city',
                                style: TextStyle(
                                  color: const Color(0xFFCBD5E1).withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fullName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialization,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF94A3B8).withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'BOOK NOW',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Doctor Avatar with Distance Ring
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: distance != null 
                                ? Colors.greenAccent.withOpacity(0.3) 
                                : Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: AppColors.cardBackground,
                          child: Text(
                            fullName.isNotEmpty ? fullName[0].toUpperCase() : 'D',
                            style: GoogleFonts.instrumentSerif(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Distance indicator dot
                      if (distance != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF0A0A0A), width: 2),
                            ),
                            child: const Icon(Icons.near_me, size: 10, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: (index * 80).ms, duration: 500.ms).slideY(begin: 0.08, end: 0),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 24),
          Text(
            'No Doctors Available',
            style: GoogleFonts.instrumentSerif(fontSize: 24, color: Colors.white.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Failed to load specialists',
              style: GoogleFonts.instrumentSerif(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadDoctors,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
