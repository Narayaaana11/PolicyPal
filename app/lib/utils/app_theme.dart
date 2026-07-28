import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // New User Enforced Luxury Color Palette
  static const Color inkBlack = Color(0xFF0D1B2A);
  static const Color prussianBlue = Color(0xFF1B263B);
  static const Color duskBlue = Color(0xFF415A77);
  static const Color dustyDenim = Color(0xFF778DA9);
  static const Color alabasterGrey = Color(0xFFE0E1DD);

  // Mapped Semantic Theme Tokens
  static const Color primaryColor = duskBlue;
  static const Color secondaryColor = dustyDenim;
  static const Color backgroundColor = inkBlack;
  static const Color cardColor = prussianBlue; 
  static const Color textPrimary = alabasterGrey;
  static const Color textSecondary = dustyDenim;
  static const Color warningColor = Color(0xFFEE9B00); 
  static const Color goldenOrange = Color(0xFFEE9B00); 
  static const Color dangerColor = Color(0xFFAE2012); 
  static const Color successColor = Color(0xFF2A9D8F);

  // Luxury Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [prussianBlue, inkBlack],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FFFFFF), // 20% white
      Color(0x0AFFFFFF), // 4% white
    ],
  );

  // Soft Ambient Shadows (Neumorphic Glow)
  static final List<BoxShadow> softGlow = [
    BoxShadow(
      color: duskBlue.withOpacity(0.15),
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> intenseGlow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 30,
      offset: const Offset(0, 15),
      spreadRadius: -5,
    ),
  ];

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: inkBlack,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: prussianBlue,
        error: dangerColor,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: textPrimary,
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: textPrimary,
          fontSize: 16,
          height: 1.5,
          letterSpacing: 0.2,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: alabasterGrey),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: alabasterGrey,
          elevation: 4,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: prussianBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: duskBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: duskBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: dustyDenim),
        hintStyle: TextStyle(color: dustyDenim.withOpacity(0.6)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
