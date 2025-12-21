import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';
import 'package:mediscanhelper/core/constants/app_strings.dart';
import 'package:mediscanhelper/core/theme/app_theme.dart';
import 'package:mediscanhelper/core/theme/settings_provider.dart';
import 'package:mediscanhelper/core/theme/theme_provider.dart';
import 'package:mediscanhelper/core/utils/feedback_service.dart';
import 'package:mediscanhelper/core/utils/notification_scheduler.dart';
import 'package:mediscanhelper/features/auth/presentation/providers/auth_provider.dart' as auth;
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:mediscanhelper/features/reminders/presentation/providers/reminder_provider.dart';
import 'package:mediscanhelper/features/splash/presentation/pages/splash_page.dart';
import 'package:mediscanhelper/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase (no explicit options so it compiles locally).
  await Firebase.initializeApp();

  // Configuration de l'orientation (portrait uniquement)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configuration de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialisation des dépendances
  await di.init();

  // Initialiser les notifications au démarrage
  await _initializeNotifications();

  runApp(const MediScanHelperApp());
}

/// Initialise et reprogramme toutes les notifications
Future<void> _initializeNotifications() async {
  try {
    final notificationScheduler = di.sl<NotificationScheduler>();
    final medicationProvider = di.sl<MedicationProvider>();
    final reminderProvider = di.sl<ReminderProvider>();

    // Charger tous les médicaments
    await medicationProvider.loadMedications();

    // Charger l'historique de traitement
    await reminderProvider.loadHistory();

    // Reprogrammer toutes les notifications
    await notificationScheduler.scheduleAllMedications(
      medicationProvider.medications,
    );

    print('✅ Notifications initialisées au démarrage');
  } catch (e) {
    print('❌ Erreur lors de l\'initialisation des notifications: $e');
  }
}

/// Application principale MediScan Helper
class MediScanHelperApp extends StatelessWidget {
  const MediScanHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => di.sl<ThemeProvider>(),
        ),
        // Settings Provider
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => di.sl<SettingsProvider>(),
        ),
        // Feedback Service Provider
        ChangeNotifierProvider<FeedbackService>(
          create: (_) => di.sl<FeedbackService>(),
        ),
        // Auth Provider
        ChangeNotifierProvider<auth.AuthProvider>(
          create: (_) => di.sl<auth.AuthProvider>(),
        ),
        // Medication Provider
        ChangeNotifierProvider<MedicationProvider>(
          create: (_) => di.sl<MedicationProvider>(),
        ),
        // Reminder Provider
        ChangeNotifierProvider<ReminderProvider>(
          create: (_) => di.sl<ReminderProvider>(),
        ),
      ],
      child: Consumer2<ThemeProvider, SettingsProvider>(
        builder: (context, themeProvider, settingsProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Localization
            locale: settingsProvider.locale,
            supportedLocales: SettingsProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Routes
            home: const SplashPage(),

            // Builder pour les animations globales
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  // Replace non-existent `textScaler` with `textScaleFactor` to
                  // prevent global text scaling from system settings.
                  textScaleFactor: 1.0,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
