import 'package:flutter/material.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';

/// Thème Material 3 pour l'application
class AppTheme {
  AppTheme._();

  /// Thème clair
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Roboto', // Default, but explicit is good. Ideally use Google Fonts if package added.

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryBlueLight.withOpacity(0.2),
      onPrimaryContainer: AppColors.primaryBlueDark,
      secondary: AppColors.secondaryGreen,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryGreenLight.withOpacity(0.2),
      onSecondaryContainer: AppColors.secondaryGreenDark,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainerHighest: AppColors.grey50, // Card backgrounds etc
      outline: AppColors.grey200,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0, // Flat app bar on scroll
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0, // Flat cards with border are trendy
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: const BorderSide(color: AppColors.grey200, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL), // Rounder buttons
        ),
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightM),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightM),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: const EdgeInsets.all(AppSizes.paddingM),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: AppSizes.elevationM,
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      shape: CircleBorder(), // Classic round FAB or RoundedRect
    ),

    // Navigation Bar Theme (Bottom Navigation)
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.primaryBlueLight.withOpacity(0.3),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    
    // Legacy BottomNavBar config (if used)
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
      bodyMedium: TextStyle(color: AppColors.textPrimaryLight),
      bodySmall: TextStyle(color: AppColors.textSecondaryLight),
    ),
  );

  /// Thème sombre
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Roboto',

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryBlueLight, // Lighter blue for dark mode
      onPrimary: AppColors.grey900,
      primaryContainer: AppColors.primaryBlueDark,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.secondaryGreenLight,
      onSecondary: AppColors.grey900,
      secondaryContainer: AppColors.secondaryGreenDark,
      onSecondaryContainer: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.grey900,
      outline: AppColors.grey700,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.grey800, // or Surface Dark
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: const BorderSide(color: AppColors.grey700, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: AppSizes.spacingM),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryBlueLight,
        foregroundColor: AppColors.grey900, // Dark text on light button
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightM),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlueLight,
        side: const BorderSide(color: AppColors.primaryBlueLight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
        ),
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightM),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey900,
      contentPadding: const EdgeInsets.all(AppSizes.paddingM),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.primaryBlueLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: AppSizes.elevationM,
      backgroundColor: AppColors.primaryBlueLight,
      foregroundColor: AppColors.grey900,
      shape: CircleBorder(),
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primaryBlueLight.withOpacity(0.3),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

     // Legacy BottomNavBar config
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryBlueLight,
      unselectedItemColor: AppColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
      bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
      bodySmall: TextStyle(color: AppColors.textSecondaryDark),
    ),
  );
}


