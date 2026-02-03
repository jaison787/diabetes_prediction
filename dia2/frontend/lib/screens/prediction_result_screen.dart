import 'package:flutter/material.dart';

class PredictionResultScreen extends StatelessWidget {
  const PredictionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    // Backend returns: prediction, probability, risk_level, risk_level_display
    final prediction = result['prediction'] as String? ?? 'Unknown';
    final probability = (result['probability'] as num?)?.toDouble() ?? 0.0;
    final riskLevel = result['risk_level'] as String? ?? 'UNKNOWN';
    final riskLevelDisplay = result['risk_level_display'] as String? ?? riskLevel;

    // Convert probability to percentage
    final score = probability * 100;

    Color resultColor = Colors.green;
    if (riskLevel == 'HIGH') resultColor = Colors.red;
    if (riskLevel == 'MEDIUM') resultColor = Colors.orange;

    final isDiabetic = prediction == 'Diabetic';

    return Scaffold(
      appBar: AppBar(title: const Text('Your Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prediction result
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: resultColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: resultColor, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      isDiabetic ? Icons.warning_rounded : Icons.check_circle,
                      size: 60,
                      color: resultColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prediction,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Risk level
              Text(
                'Risk Level: $riskLevelDisplay',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: resultColor),
              ),
              const SizedBox(height: 10),
              
              // Probability score
              Text(
                '${score.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
              ),
              const Text('Probability', style: TextStyle(fontSize: 16, color: Colors.grey)),
              
              const SizedBox(height: 30),
              
              if (riskLevel != 'LOW') ...[
                const Text(
                  'Based on your parameters, we recommend consulting a specialist.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/doctor-list'),
                  icon: const Icon(Icons.local_hospital),
                  label: const Text('Find Nearby Doctors'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ] else ...[
                const Text(
                  'Great! Your risk level is low. Keep maintaining a healthy lifestyle.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
              
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
