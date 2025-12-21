import 'package:flutter/material.dart';

/// Couleurs principales de l'application
class AppColors {
  AppColors._();

  // Primary Palette (Royal Blue)
  static const Color primaryBlue = Color(0xFF2563EB); // Blue 600
  static const Color primaryBlueDark = Color(0xFF1E40AF); // Blue 800
  static const Color primaryBlueLight = Color(0xFF60A5FA); // Blue 400

  // Semantic Alias
  static const Color primary = primaryBlue;

  // Secondary Palette (Teal/Mint)
  // Renaming 'secondaryGreen' maintenance aliases for existing code compatibility
  // but pointing to new Teal colors
  static const Color secondaryGreen = Color(0xFF0D9488); // Teal 600
  static const Color secondaryGreenDark = Color(0xFF115E59); // Teal 800
  static const Color secondaryGreenLight = Color(0xFF2DD4BF); // Teal 400

  // Semantic Alias
  static const Color secondary = secondaryGreen;
  static const Color accent = secondaryGreenLight;

  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color activeLight = Color(0xFFEFF6FF); // Blue 50

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF8FAFC); // Slate 50
  static const Color grey100 = Color(0xFFF1F5F9); // Slate 100
  static const Color grey200 = Color(0xFFE2E8F0); // Slate 200
  static const Color grey300 = Color(0xFFCBD5E1); // Slate 300
  static const Color grey400 = Color(0xFF94A3B8); // Slate 400
  static const Color grey500 = Color(0xFF64748B); // Slate 500
  static const Color grey600 = Color(0xFF475569); // Slate 600
  static const Color grey700 = Color(0xFF334155); // Slate 700
  static const Color grey800 = Color(0xFF1E293B); // Slate 800
  static const Color grey900 = Color(0xFF0F172A); // Slate 900

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, secondaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [primaryBlueDark, primaryBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x99FFFFFF), // White with opacity
      Color(0x4DFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

   static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [
      Color(0x991E293B), // Slate 800 with opacity
      Color(0x4D1E293B),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Expiry Status Colors
  static const Color expiryGood = Color(0xFF10B981); // Emerald 500
  static const Color expiryWarning = Color(0xFFF59E0B); // Amber 500
  static const Color expiryExpired = Color(0xFFEF4444); // Red 500

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate 900
  static const Color textSecondaryLight = Color(0xFF475569); // Slate 600
  static const Color textPrimaryDark = Color(0xFFF1F5F9); // Slate 100
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
}

