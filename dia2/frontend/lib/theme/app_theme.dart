import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF000000);
  static const Color cardBackground = Color(0x0DFFFFFF); // rgba(255, 255, 255, 0.05)
  static const Color cardBackgroundBright = Color(0x14FFFFFF); // rgba(255, 255, 255, 0.08)
  static const Color cardBorder = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)
  static const Color cardBorderBright = Color(0x26FFFFFF); // rgba(255, 255, 255, 0.15)
  
  static const Color silver100 = Color(0xFFF1F5F9);
  static const Color silver200 = Color(0xFFE2E8F0);
  static const Color silver300 = Color(0xFFCBD5E1);
  static const Color silver400 = Color(0xFF94A3B8);
  static const Color silver500 = Color(0xFF64748B);
  static const Color silver600 = Color(0xFF475569);

  static const LinearGradient silverGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0xFF94A3B8),
    ],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: AppColors.silver400,
        surface: AppColors.cardBackground,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        elevation: 0,
      ),
      useMaterial3: true,
    );
  }
}
