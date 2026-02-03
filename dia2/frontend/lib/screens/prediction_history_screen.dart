import 'package:flutter/material.dart';
import '../services/prediction_service.dart';

class PredictionHistoryScreen extends StatelessWidget {
  const PredictionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Prediction History')),
      body: FutureBuilder<List<dynamic>>(
        future: PredictionService().getXGBoostHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('No saved predictions.', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final riskLevel = item['risk_level'] as String? ?? 'UNKNOWN';
              final probabilityScore = (item['probability_score'] as num?)?.toDouble() ?? 0.0;
              final predictionResult = item['prediction_result'] as bool? ?? false;
              final createdAt = item['created_at']?.toString().split('T')[0] ?? 'Unknown';
              
              Color levelColor = Colors.green;
              if (riskLevel == 'HIGH') levelColor = Colors.red;
              if (riskLevel == 'MEDIUM') levelColor = Colors.orange;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: levelColor.withOpacity(0.2),
                    child: Icon(
                      predictionResult ? Icons.warning : Icons.check,
                      color: levelColor,
                    ),
                  ),
                  title: Text(
                    predictionResult ? 'Diabetic' : 'Non-Diabetic',
                    style: TextStyle(fontWeight: FontWeight.bold, color: levelColor),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text('Probability: ${(probabilityScore * 100).toStringAsFixed(1)}%'),
                      Text('Risk Level: ${riskLevel.toLowerCase().replaceFirst(riskLevel[0].toLowerCase(), riskLevel[0])}'),
                      Text('Date: $createdAt', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  trailing: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: levelColor, shape: BoxShape.circle),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
