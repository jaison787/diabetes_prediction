import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/prediction_service.dart';
import '../theme/app_theme.dart';

class PredictionFormScreen extends StatefulWidget {
  const PredictionFormScreen({super.key});

  @override
  State<PredictionFormScreen> createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _bmiController = TextEditingController();
  final _hbA1cController = TextEditingController();
  final _glucoseController = TextEditingController();
  
  String _gender = 'Male';
  int _hypertension = 0;
  int _heartDisease = 0;
  String _smokingHistory = 'never';
  
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final result = await PredictionService().predictXGBoost({
        'gender': _gender,
        'age': double.parse(_ageController.text),
        'hypertension': _hypertension,
        'heart_disease': _heartDisease,
        'smoking_history': _smokingHistory,
        'bmi': double.parse(_bmiController.text),
        'hba1c_level': double.parse(_hbA1cController.text),
        'blood_glucose_level': double.parse(_glucoseController.text),
      });
      if (mounted) {
        Navigator.pushNamed(context, '/prediction-result', arguments: result);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        )
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Risk Assessment',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Clinical Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ).animate().fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 8),
              const Text(
                'Enter patient metrics for high-precision diabetes risk assessment.',
                style: TextStyle(color: AppColors.silver500, fontSize: 14),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('GENDER'),
                        _buildDropdownGender(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('AGE'),
                        _buildTextField(_ageController, 'e.g. 45', keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildSwitchCard(
                'Hypertension',
                'History of high blood pressure',
                Icons.monitor_heart,
                _hypertension == 1,
                (val) => setState(() => _hypertension = val ? 1 : 0),
              ),
              const SizedBox(height: 12),
              _buildSwitchCard(
                'Heart Disease',
                'Any cardiovascular conditions',
                Icons.favorite,
                _heartDisease == 1,
                (val) => setState(() => _heartDisease = val ? 1 : 0),
              ),
              const SizedBox(height: 24),
              
              _buildLabel('SMOKING HISTORY'),
              _buildDropdownSmoking(),
              const SizedBox(height: 16),
              
              _buildLabel('BODY MASS INDEX (BMI)'),
              _buildTextField(_bmiController, '24.5', suffix: 'kg/m²', keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('HBA1C LEVEL'),
                        _buildTextField(_hbA1cController, '5.7', suffix: '%', keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('BLOOD GLUCOSE'),
                        _buildTextField(_glucoseController, '140', suffix: 'mg/dL', keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              
              _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
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
                          Icon(Icons.analytics_outlined),
                          SizedBox(width: 12),
                          Text('RUN RISK ASSESSMENT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 120), // Padding for bottom nav
            ],
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
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

  Widget _buildTextField(TextEditingController controller, String hint, {String? suffix, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) => v!.isEmpty ? 'Required' : null,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: AppColors.silver500, fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildSwitchCard(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.silver200, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.silver400,
            inactiveThumbColor: Colors.white60,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownGender() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _gender,
          isExpanded: true,
          dropdownColor: const Color(0xFF111111),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (val) => setState(() => _gender = val!),
        ),
      ),
    );
  }

  Widget _buildDropdownSmoking() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _smokingHistory,
          isExpanded: true,
          dropdownColor: const Color(0xFF111111),
          items: const [
            DropdownMenuItem(value: 'never', child: Text('Never')),
            DropdownMenuItem(value: 'former', child: Text('Former')),
            DropdownMenuItem(value: 'current', child: Text('Current')),
            DropdownMenuItem(value: 'ever', child: Text('Ever')),
            DropdownMenuItem(value: 'not current', child: Text('Not Current')),
            DropdownMenuItem(value: 'No Info', child: Text('No Info')),
          ],
          onChanged: (val) => setState(() => _smokingHistory = val!),
        ),
      ),
    );
  }
}
