import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HyHTheme {
  const HyHTheme._();

  static ThemeData dark() {
    const primaryColor = Color(0xFFFFD700);
    const backgroundColor = Color(0xFF000000);
    const surfaceColor = Color(0xFF0A0A0A);
    const textColor = Color(0xFFFFFFFF);
    const mutedColor = Color(0xFFBFBFBF);

    final baseTheme = ThemeData.dark();

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.robotoSlab(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: mutedColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.inter(),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textColor,
        error: Color(0xFFFF4D4D),
        brightness: Brightness.dark,
      ),
      textTheme: baseTheme.textTheme.copyWith(
        displayLarge: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.robotoSlab(color: textColor, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(color: textColor),
        bodyMedium: GoogleFonts.inter(color: textColor),
        labelLarge: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
      ).apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: primaryColor),
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
        labelStyle: GoogleFonts.inter(color: mutedColor),
        hintStyle: GoogleFonts.inter(color: mutedColor.withOpacity(0.7)),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor.withOpacity(0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2E2E2E)),
        ),
      ),
      dividerColor: const Color(0xFF2E2E2E),
    );
  }
}
