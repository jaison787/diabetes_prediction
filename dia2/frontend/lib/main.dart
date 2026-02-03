import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/prediction_form_screen.dart';
import 'screens/prediction_result_screen.dart';
import 'screens/doctor_list_screen.dart';
import 'screens/book_appointment_screen.dart';
import 'screens/my_appointments_screen.dart';
import 'screens/prediction_history_screen.dart';
import 'screens/manage_slots_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'DiaPredict 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const HomeDashboard(),
        '/predict': (context) => const PredictionFormScreen(),
        '/prediction-result': (context) => const PredictionResultScreen(),
        '/doctor-list': (context) => const DoctorListScreen(),
        '/book-appointment': (context) => const BookAppointmentScreen(),
        '/my-appointments': (context) => const MyAppointmentsScreen(),
        '/prediction-history': (context) => const PredictionHistoryScreen(),
        '/manage-slots': (context) => const ManageSlotsScreen(),
      },
      home: const LoginScreen(),
    );
  }
}
