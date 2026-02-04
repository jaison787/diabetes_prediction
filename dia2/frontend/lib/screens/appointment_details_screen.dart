import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final name = appointment['doctor_name'] ?? appointment['patient_name'] ?? 'Doctor Name';
    final role = appointment['specialization'] ?? 'Specialist';
    final date = appointment['slot_details']['date'] ?? 'March 25th';
    final time = appointment['slot_details']['start_time'] ?? '12:30 PM';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                _buildHeader(context),
                const SizedBox(height: 40),
                _buildDoctorInfo(name, role, date, time),
                const SizedBox(height: 48),
                _buildActionGrid(),
                const SizedBox(height: 48),
                _buildChecklistSection(),
                const SizedBox(height: 40),
                _buildInsuranceSection(),
                const SizedBox(height: 40),
                _buildLocationSection(),
                const SizedBox(height: 140), // Space for bottom buttons
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
          
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const Text(
          'APPOINTMENT',
          style: TextStyle(color: AppColors.silver300, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.white),
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: AppColors.cardBackground,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo(String name, String role, String date, String time) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const CircleAvatar(
            radius: 56,
            backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDyxoWDidlcK9jdFEBts3559-NnJfKwWt9r9jE8jfNPVtGaujIJMUOoLGXNumBl5j8M9he9isejyBD1nnfkR2Pg6FoIYBvFt2ASUD1NhYZMVZ78acHENAT7i-wE5KkQdLxIParA1XrJdJ4P95HbHFU3MHF79g0s2WYvY5MyjmciFAZBObmWgFeNE99ZJEopxcpkq8QsCStwnPYF50943Ia889XYL5DS2PlT73tnDDkFNeLb-UHgcUZC6F9OUx0gV11afabfQaBXNm4'),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
        ),
        Text(
          '$role • Diabetes Specialist',
          style: const TextStyle(color: AppColors.silver400, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month, color: AppColors.silver300, size: 18),
              const SizedBox(width: 8),
              Text(
                '$date, $time',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.call, 'Call'),
        _buildActionButton(Icons.event_available, 'Calendar'),
        _buildActionButton(Icons.directions, 'Directions'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          label.toUpperCase(),
          style: const TextStyle(color: AppColors.silver400, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.task_alt, color: AppColors.silver400, size: 20),
            SizedBox(width: 8),
            Text(
              'CHECKLIST',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildChecklistItem('Medical insurance', 'Required for claim', false),
        const SizedBox(height: 12),
        _buildChecklistItem('Upload Photo ID', 'Completed', true),
      ],
    );
  }

  Widget _buildChecklistItem(String title, String status, bool completed) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: completed ? Colors.white.withOpacity(0.05) : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: completed ? Colors.white.withOpacity(0.1) : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: completed ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: completed ? Colors.white : Colors.white24),
            ),
            child: completed ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(color: completed ? AppColors.silver200 : AppColors.silver500, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildInsuranceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INSURANCE DETAILS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.05), Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('PROVIDER', style: TextStyle(color: AppColors.silver500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      SizedBox(height: 4),
                      Text('Medicare Original Part A & B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: AppColors.cardBackground, shape: BoxShape.circle),
                    child: const Icon(Icons.info_outline, size: 16, color: Colors.white),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white10),
              ),
              const Text('MEMBER ID', style: TextStyle(color: AppColors.silver500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 4),
              const Text('1EG4-TE5-MK21', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OFFICE LOCATION',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(32),
            image: const DecorationImage(
              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDdb6R6EKo3NI00hZho2ViBFU7ykCllxuefZ3kK50PCzJ6-JR_fA8W_wc99oHAPIx4eUf5r2OVXwebRShe9nXQTiypmA9bfe7ZhSqiSOvacGqXTLZKGvIOf9JBG2I1_HXbva1N1b58wSULY2xs4bvTAGGrWQZceKgfAnqS8AOZLh3w_fGR_l_iM7ptYndiD49H4W5CNBE7p-Q-oNZHaEo4oaEtxN2aPf0Rj24X722gHrhOj7sdVMaDzN5hfqcgJzWq2IHPxX23qsHE'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 20)],
                ),
                child: const Icon(Icons.location_on, color: Colors.black, size: 24),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
                  child: const Text('OPEN IN MAPS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit_calendar_outlined, size: 18),
                    SizedBox(width: 12),
                    Text('MODIFY APPOINTMENT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
                child: const Text('CANCEL APPOINTMENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
