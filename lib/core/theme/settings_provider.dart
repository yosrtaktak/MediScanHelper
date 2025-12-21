import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider pour la gestion des paramètres de l'application
class SettingsProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  static const String _notificationsKey = 'notifications_enabled';

  final SharedPreferences _prefs;

  Locale _locale = const Locale('fr', 'FR');
  bool _notificationsEnabled = true;

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  /// Getters
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;

  /// Charge les paramètres depuis les préférences
  Future<void> _loadSettings() async {
    final String? savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      }
    }

    _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;
    notifyListeners();
  }

  /// Change la locale
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
    notifyListeners();
  }

  /// Active/désactive les notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs.setBool(_notificationsKey, enabled);
    notifyListeners();
  }

  /// Liste des locales supportées
  static const List<Locale> supportedLocales = [
    Locale('fr', 'FR'),
    Locale('en', 'US'),
  ];

  /// Obtient le nom de la langue actuelle
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }
}

