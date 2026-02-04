import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Doctor-specific fields
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _licenseController = TextEditingController();
  final _cityController = TextEditingController();
  String _specialization = 'GENERAL';
  
  String _selectedRole = 'USER';
  bool _isLoading = false;
  String? _error;

  final List<Map<String, String>> _specializationOptions = [
    {'value': 'GENERAL', 'label': 'General Physician'},
    {'value': 'DIABETOLOGIST', 'label': 'Diabetologist'},
    {'value': 'ENDOCRINOLOGIST', 'label': 'Endocrinologist'},
    {'value': 'CARDIOLOGIST', 'label': 'Cardiologist'},
    {'value': 'NUTRITIONIST', 'label': 'Nutritionist'},
    {'value': 'OTHER', 'label': 'Other'},
  ];

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      if (_selectedRole == 'DOCTOR') {
        await AuthService().registerDoctor(
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirm: _passwordConfirmController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text,
          specialization: _specialization,
          qualification: _qualificationController.text,
          experienceYears: int.tryParse(_experienceController.text) ?? 0,
          licenseNumber: _licenseController.text,
          city: _cityController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration submitted! Please wait for admin approval.')),
          );
          Navigator.pop(context);
        }
      } else {
        await AuthService().register(
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirm: _passwordConfirmController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text,
          role: _selectedRole,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful! Please login.')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Light Effects
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 8.seconds),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.silverGradient.createShader(bounds),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0),
                  
                  const Text(
                    'Join the DiaPredict health network',
                    style: TextStyle(
                      color: AppColors.silver500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  
                  const SizedBox(height: 32),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDropdownRole(),
                        const SizedBox(height: 24),
                        
                        _buildLabel('FIRST NAME'),
                        _buildTextField(_firstNameController, 'John', validator: (v) => v!.isEmpty ? 'Required' : null),
                        const SizedBox(height: 16),
                        
                        _buildLabel('LAST NAME'),
                        _buildTextField(_lastNameController, 'Doe', validator: (v) => v!.isEmpty ? 'Required' : null),
                        const SizedBox(height: 16),
                        
                        _buildLabel('EMAIL'),
                        _buildTextField(_emailController, 'john.doe@example.com', keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
                        const SizedBox(height: 16),
                        
                        _buildLabel('PHONE'),
                        _buildTextField(_phoneController, '+1 234 567 8900', keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        
                        _buildLabel('PASSWORD'),
                        _buildTextField(_passwordController, '••••••••', obscureText: true, validator: (v) => v!.length < 6 ? 'Min 6 characters' : null),
                        const SizedBox(height: 16),
                        
                        _buildLabel('CONFIRM PASSWORD'),
                        _buildTextField(_passwordConfirmController, '••••••••', obscureText: true, validator: (v) => v != _passwordController.text ? 'Passwords must match' : null),
                        
                        if (_selectedRole == 'DOCTOR') ...[
                          const SizedBox(height: 32),
                          const Divider(color: AppColors.cardBorder),
                          const SizedBox(height: 24),
                          const Text(
                            'DOCTOR INFORMATION',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          const SizedBox(height: 24),
                          
                          _buildLabel('SPECIALIZATION'),
                          _buildDropdownSpecialization(),
                          const SizedBox(height: 16),
                          
                          _buildLabel('QUALIFICATION'),
                          _buildTextField(_qualificationController, 'e.g., MBBS, MD', validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),
                          
                          _buildLabel('YEARS OF EXPERIENCE'),
                          _buildTextField(_experienceController, 'e.g., 5', keyboardType: TextInputType.number, validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),
                          
                          _buildLabel('MEDICAL LICENSE NUMBER'),
                          _buildTextField(_licenseController, 'License number', validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),
                          
                          _buildLabel('CITY'),
                          _buildTextField(_cityController, 'Your city', validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null),
                        ],
                        
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ).animate().shake(),
                        ],
                        
                        const SizedBox(height: 32),
                        
                        _isLoading 
                          ? const Center(child: CircularProgressIndicator(color: Colors.white))
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: _register, 
                                child: Text(
                                  _selectedRole == 'DOCTOR' ? 'SUBMIT FOR APPROVAL' : 'SIGN UP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.silver500,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool obscureText = false, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdownRole() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          isExpanded: true,
          dropdownColor: const Color(0xFF111111),
          items: const [
            DropdownMenuItem(value: 'USER', child: Text('I am a Patient')),
            DropdownMenuItem(value: 'DOCTOR', child: Text('I am a Doctor')),
          ],
          onChanged: (val) => setState(() => _selectedRole = val!),
        ),
      ),
    );
  }

  Widget _buildDropdownSpecialization() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _specialization,
          isExpanded: true,
          dropdownColor: const Color(0xFF111111),
          items: _specializationOptions.map((s) => 
            DropdownMenuItem(value: s['value'], child: Text(s['label']!))
          ).toList(),
          onChanged: (val) => setState(() => _specialization = val!),
        ),
      ),
    );
  }
}
