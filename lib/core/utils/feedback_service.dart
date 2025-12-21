import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Types de feedback sonore disponibles
enum SoundType {
  click,
  success,
  error,
  notification,
  warning,
}

/// Types de feedback haptique disponibles
enum HapticType {
  light,
  medium,
  heavy,
  selection,
  success,
  warning,
  error,
}

/// Service de gestion du feedback utilisateur (son et vibration)
class FeedbackService extends ChangeNotifier {
  static const String _soundEnabledKey = 'feedback_sound_enabled';
  static const String _vibrationEnabledKey = 'feedback_vibration_enabled';

  final SharedPreferences _prefs;

  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  FeedbackService(this._prefs) {
    _loadPreferences();
  }

  /// Charge les préférences
  Future<void> _loadPreferences() async {
    _soundEnabled = _prefs.getBool(_soundEnabledKey) ?? true;
    _vibrationEnabled = _prefs.getBool(_vibrationEnabledKey) ?? true;
    notifyListeners();
  }

  /// Getters
  bool get isSoundEnabled => _soundEnabled;
  bool get isVibrationEnabled => _vibrationEnabled;
  bool get hasVibrator => true; // HapticFeedback is available on all platforms

  /// Active/désactive le son
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _prefs.setBool(_soundEnabledKey, enabled);
    notifyListeners();
  }

  /// Active/désactive la vibration
  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    await _prefs.setBool(_vibrationEnabledKey, enabled);
    notifyListeners();
  }

  /// Joue un son système
  Future<void> playSound(SoundType type) async {
    if (!_soundEnabled) return;

    try {
      switch (type) {
        case SoundType.click:
          // Short beep for click
          await FlutterRingtonePlayer().play(
            fromAsset: "assets/sounds/click.mp3",
            volume: 0.3,
            looping: false,
          );
          break;
        case SoundType.success:
          // System notification sound for success
          await FlutterRingtonePlayer().play(
            android: AndroidSounds.notification,
            ios: IosSounds.bell,
            volume: 0.5,
            looping: false,
          );
          break;
        case SoundType.error:
          // System alarm sound for error
          await FlutterRingtonePlayer().play(
            android: AndroidSounds.alarm,
            ios: IosSounds.alarm,
            volume: 0.5,
            looping: false,
          );
          break;
        case SoundType.notification:
          // Default notification sound
          await FlutterRingtonePlayer().play(
            android: AndroidSounds.notification,
            ios: IosSounds.triTone,
            volume: 0.4,
            looping: false,
          );
          break;
        case SoundType.warning:
          // Ringtone for warning
          await FlutterRingtonePlayer().play(
            android: AndroidSounds.ringtone,
            ios: IosSounds.glass,
            volume: 0.4,
            looping: false,
          );
          break;
      }
    } catch (e) {
      // Échec silencieux - le son n'est pas critique
      print('Error playing sound: $e');
    }
  }

  /// Effectue une vibration
  Future<void> vibrate(HapticType type) async {
    if (!_vibrationEnabled) return;

    try {
      switch (type) {
        case HapticType.light:
          await HapticFeedback.lightImpact();
          break;
        case HapticType.medium:
          await HapticFeedback.mediumImpact();
          break;
        case HapticType.heavy:
          await HapticFeedback.heavyImpact();
          break;
        case HapticType.selection:
          await HapticFeedback.selectionClick();
          break;
        case HapticType.success:
          // Single light vibration for success
          await HapticFeedback.lightImpact();
          break;
        case HapticType.warning:
          // Medium vibration for warning
          await HapticFeedback.mediumImpact();
          break;
        case HapticType.error:
          // Double heavy vibration pattern for error
          await HapticFeedback.heavyImpact();
          await Future.delayed(const Duration(milliseconds: 50));
          await HapticFeedback.heavyImpact();
          break;
      }
    } catch (e) {
      // Échec silencieux - la vibration n'est pas critique
      print('Error vibrating: $e');
    }
  }

  /// Feedback combiné pour un clic
  Future<void> click() async {
    await Future.wait([
      playSound(SoundType.click),
      vibrate(HapticType.light),
    ]);
  }

  /// Feedback combiné pour une sélection
  Future<void> selection() async {
    await Future.wait([
      playSound(SoundType.click),
      vibrate(HapticType.selection),
    ]);
  }

  /// Feedback combiné pour un succès
  Future<void> success() async {
    await Future.wait([
      playSound(SoundType.success),
      vibrate(HapticType.success),
    ]);
  }

  /// Feedback combiné pour une erreur
  Future<void> error() async {
    await Future.wait([
      playSound(SoundType.error),
      vibrate(HapticType.error),
    ]);
  }

  /// Feedback combiné pour un avertissement
  Future<void> warning() async {
    await Future.wait([
      playSound(SoundType.warning),
      vibrate(HapticType.warning),
    ]);
  }

  /// Feedback combiné pour une notification
  Future<void> notification() async {
    await Future.wait([
      playSound(SoundType.notification),
      vibrate(HapticType.medium),
    ]);
  }

}

