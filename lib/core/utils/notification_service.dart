import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

/// Service pour gérer les notifications locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialise le service de notifications
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialiser les timezones
    tz.initializeTimeZones();
    // Utiliser le fuseau horaire local de l'appareil
    final String timeZoneName = _getLocalTimeZone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    print('🌍 Fuseau horaire configuré: $timeZoneName');

    // Configuration Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configuration globale
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Obtient le fuseau horaire local de l'appareil
  String _getLocalTimeZone() {
    // Obtenir l'offset UTC de l'appareil
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    // Convertir l'offset en heures
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);

    try {
      // Essayer d'utiliser le fuseau horaire par défaut du système
      final timeZoneName = DateTime.now().timeZoneName;

      // Liste des fuseaux horaires communs qui fonctionnent avec la bibliothèque timezone
      final commonTimezones = {
        'UTC': 'UTC',
        'GMT': 'GMT',
        'EST': 'America/New_York',
        'EDT': 'America/New_York',
        'CST': 'America/Chicago',
        'CDT': 'America/Chicago',
        'MST': 'America/Denver',
        'MDT': 'America/Denver',
        'PST': 'America/Los_Angeles',
        'PDT': 'America/Los_Angeles',
        'CET': 'Europe/Paris',
        'CEST': 'Europe/Paris',
        'BST': 'Europe/London',
        'JST': 'Asia/Tokyo',
        'AEST': 'Australia/Sydney',
        'AEDT': 'Australia/Sydney',
      };

      // Si c'est un fuseau horaire commun, utiliser le mapping
      if (commonTimezones.containsKey(timeZoneName)) {
        return commonTimezones[timeZoneName]!;
      }

      // Sinon, essayer de deviner en fonction de l'offset
      // Europe/Paris = UTC+1 en hiver, UTC+2 en été
      if (hours == 1 || hours == 2) {
        return 'Europe/Paris';
      }
      // UTC+0 ou UTC+1 (Londres)
      else if (hours == 0) {
        return 'Europe/London';
      }
      // Amérique du Nord
      else if (hours == -5 || hours == -4) {
        return 'America/New_York';
      } else if (hours == -6 || hours == -5) {
        return 'America/Chicago';
      } else if (hours == -7 || hours == -6) {
        return 'America/Denver';
      } else if (hours == -8 || hours == -7) {
        return 'America/Los_Angeles';
      }

      // Par défaut, utiliser UTC
      print('⚠️ Fuseau horaire non reconnu: $timeZoneName (offset: ${hours}h${minutes}m), utilisation UTC');
      return 'UTC';
    } catch (e) {
      print('⚠️ Erreur détection fuseau horaire: $e, utilisation UTC');
      return 'UTC';
    }
  }

  /// Demande la permission pour les notifications
  Future<bool> requestPermission() async {
    // Vérifier la permission de notification
    if (!await Permission.notification.isGranted) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        print('❌ Permission de notification refusée');
        return false;
      }
    }

    // Pour Android 12+ (API 31+), vérifier la permission SCHEDULE_EXACT_ALARM
    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        final status = await Permission.scheduleExactAlarm.request();
        if (!status.isGranted) {
          print('⚠️ Permission SCHEDULE_EXACT_ALARM refusée - les notifications peuvent ne pas être exactes');
          // Ne pas retourner false car les notifications peuvent quand même fonctionner
        } else {
          print('✅ Permission SCHEDULE_EXACT_ALARM accordée');
        }
      }
    } catch (e) {
      // Cette permission n'existe pas sur les versions Android plus anciennes
      print('ℹ️ Permission SCHEDULE_EXACT_ALARM non disponible sur cette version Android');
    }

    return true;
  }

  /// Callback quand une notification est tappée
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navigation vers la page des médicaments ou rappels
    print('Notification tapped: ${response.payload}');
  }

  /// Schedule une notification quotidienne
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    bool sound = true,
    bool vibration = true,
  }) async {
    await initialize();

    // Obtenir l'heure actuelle dans le fuseau horaire local
    final now = tz.TZDateTime.now(tz.local);

    // Créer la date/heure pour la notification en utilisant le fuseau horaire local
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0,
      0,
    );

    // Si l'heure est déjà passée aujourd'hui, planifier pour demain
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      print('⏭️ L\'heure est passée aujourd\'hui, planification pour demain');
    }

    // Afficher les informations de debug
    print('📅 Planification notification #$id:');
    print('   Heure actuelle: ${now.hour}:${now.minute.toString().padLeft(2, '0')} (${now.timeZoneName})');
    print('   Heure cible: ${hour}:${minute.toString().padLeft(2, '0')}');
    print('   Date planifiée: $scheduledDate');
    print('   Fuseau horaire: ${tz.local.name}');

    // Détails Android
    final androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Rappels de Médicaments',
      channelDescription: 'Notifications pour vos prises de médicaments',
      importance: Importance.max,
      priority: Priority.high,
      playSound: sound,
      enableVibration: vibration,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(body),
      actions: [
        const AndroidNotificationAction(
          'mark_taken',
          'Pris',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'snooze',
          'Reporter 15 min',
        ),
      ],
    );

    // Détails iOS
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: sound,
      sound: sound ? 'default' : null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Planifier la notification quotidienne
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Répéter quotidiennement
    );

    print('✅ Notification planifiée: $title à ${hour}h${minute.toString().padLeft(2, '0')}');
    print('   Prochaine occurrence: $scheduledDate');
    print('   Mode: AndroidScheduleMode.exactAllowWhileIdle');
    print('   Répétition: quotidienne (matchDateTimeComponents.time)');
  }

  /// Annule une notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print('❌ Notification annulée: $id');
  }

  /// Annule toutes les notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('❌ Toutes les notifications annulées');
  }

  /// Affiche une notification immédiate (pour test)
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Rappels de Médicaments',
      channelDescription: 'Notifications pour vos prises de médicaments',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
    print('🔔 Notification immédiate affichée: $title');
  }

  /// Liste toutes les notifications planifiées
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Vérifie si une notification est planifiée
  Future<bool> isNotificationScheduled(int id) async {
    final pending = await getPendingNotifications();
    return pending.any((notif) => notif.id == id);
  }

  /// Planifie une notification de test pour dans 1 minute (pour debug)
  Future<void> scheduleTestNotification() async {
    await initialize();
    await requestPermission();

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));

    print('🧪 Test notification planifiée pour: $scheduledDate');
    print('   Heure actuelle: ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    print('   Heure test: ${scheduledDate.hour}:${scheduledDate.minute.toString().padLeft(2, '0')}');

    const androidDetails = AndroidNotificationDetails(
      'medication_reminders',
      'Rappels de Médicaments',
      channelDescription: 'Notifications pour vos prises de médicaments',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      999999, // ID unique pour le test
      '🧪 Test de notification',
      'Si vous voyez ceci, les notifications fonctionnent ! Heure actuelle du device: ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('✅ Notification de test planifiée avec succès');
  }
}
