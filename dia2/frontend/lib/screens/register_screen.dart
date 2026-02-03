import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
        _error = e.toString();
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
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic fields
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                validator: (v) => v != _passwordController.text ? 'Passwords must match' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'USER', child: Text('Patient')),
                  DropdownMenuItem(value: 'DOCTOR', child: Text('Doctor')),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              
              // Doctor-specific fields
              if (_selectedRole == 'DOCTOR') ...[
                const SizedBox(height: 20),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Doctor Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                DropdownButtonFormField<String>(
                  value: _specialization,
                  decoration: const InputDecoration(labelText: 'Specialization', border: OutlineInputBorder()),
                  items: _specializationOptions.map((s) => 
                    DropdownMenuItem(value: s['value'], child: Text(s['label']!))
                  ).toList(),
                  onChanged: (val) => setState(() => _specialization = val!),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _qualificationController,
                  decoration: const InputDecoration(
                    labelText: 'Qualification', 
                    hintText: 'e.g., MBBS, MD',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Years of Experience', 
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _licenseController,
                  decoration: const InputDecoration(
                    labelText: 'Medical License Number', 
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City', 
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _selectedRole == 'DOCTOR' && v!.isEmpty ? 'Required' : null,
                ),
              ],
              
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
