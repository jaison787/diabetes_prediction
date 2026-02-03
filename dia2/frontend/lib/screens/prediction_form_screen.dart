import 'package:flutter/material.dart';
import '../services/prediction_service.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diabetes Risk Assessment')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _gender = val!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _bmiController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'BMI', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _hbA1cController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'HbA1c Level', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _glucoseController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Blood Glucose Level', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              SwitchListTile(
                title: const Text('Hypertension'),
                subtitle: const Text('Do you have high blood pressure?'),
                value: _hypertension == 1,
                onChanged: (val) => setState(() => _hypertension = val ? 1 : 0),
              ),
              SwitchListTile(
                title: const Text('Heart Disease'),
                subtitle: const Text('Do you have any heart condition?'),
                value: _heartDisease == 1,
                onChanged: (val) => setState(() => _heartDisease = val ? 1 : 0),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _smokingHistory,
                decoration: const InputDecoration(labelText: 'Smoking History', border: OutlineInputBorder()),
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
              const SizedBox(height: 30),
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Predict Risk', style: TextStyle(fontSize: 18)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
