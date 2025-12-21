import 'package:mediscanhelper/core/utils/notification_service.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';

/// Service pour planifier et reprogrammer les notifications des médicaments
class NotificationScheduler {
  final NotificationService _notificationService;

  NotificationScheduler(this._notificationService);

  /// Programme toutes les notifications pour un médicament
  Future<void> scheduleMedicationNotifications(Medication medication) async {
    // S'assurer que le service de notification est initialisé
    await _notificationService.initialize();

    // Demander les permissions si nécessaire
    final hasPermission = await _notificationService.requestPermission();
    if (!hasPermission) {
      print('⚠️ Permissions de notification non accordées pour ${medication.name}');
      return;
    }

    if (!medication.isActive) {
      // Si le médicament n'est pas actif, annuler ses notifications
      await cancelMedicationNotifications(medication);
      return;
    }

    // Si le traitement est terminé, annuler les notifications
    if (medication.isTreatmentCompleted) {
      await cancelMedicationNotifications(medication);
      return;
    }

    // D'abord, annuler toutes les notifications existantes pour ce médicament
    // pour éviter les doublons
    await cancelMedicationNotifications(medication);

    // Planifier une notification pour chaque heure de prise
    for (int i = 0; i < medication.times.length; i++) {
      final time = medication.times[i];
      final notificationId = _generateNotificationId(medication.id, i);

      await _notificationService.scheduleDailyNotification(
        id: notificationId,
        title: '💊 ${medication.name}',
        body: 'Il est temps de prendre votre médicament (${medication.dosage})',
        hour: time.hour,
        minute: time.minute,
        sound: true,
        vibration: true,
      );

      print('🔔 Notification planifiée pour ${medication.name} à ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
    }
  }

  /// Annule toutes les notifications pour un médicament
  Future<void> cancelMedicationNotifications(Medication medication) async {
    for (int i = 0; i < medication.times.length; i++) {
      final notificationId = _generateNotificationId(medication.id, i);
      await _notificationService.cancelNotification(notificationId);
    }
    print('❌ Notifications annulées pour ${medication.name}');
  }

  /// Programme les notifications pour tous les médicaments actifs
  Future<void> scheduleAllMedications(List<Medication> medications) async {
    // Initialiser le service de notification
    await _notificationService.initialize();

    // Demander les permissions
    final hasPermission = await _notificationService.requestPermission();
    if (!hasPermission) {
      print('⚠️ Permissions de notification non accordées - impossible de planifier les notifications');
      return;
    }

    // Annuler toutes les notifications existantes
    await _notificationService.cancelAllNotifications();

    int totalScheduled = 0;

    // Planifier les notifications pour chaque médicament actif
    for (final medication in medications) {
      if (medication.isActive && !medication.isTreatmentCompleted) {
        await scheduleMedicationNotifications(medication);
        totalScheduled += medication.times.length;
      }
    }

    print('✅ Total de $totalScheduled notifications planifiées pour ${medications.length} médicaments');

    // Afficher les notifications en attente pour vérification
    final pending = await _notificationService.getPendingNotifications();
    print('📋 Notifications en attente: ${pending.length}');
    for (final notif in pending) {
      print('   - ID ${notif.id}: ${notif.title} - ${notif.body}');
    }
  }

  /// Génère un ID unique pour une notification
  /// Format: hash du medicationId + index de l'heure
  /// IMPORTANT: Cette méthode doit être utilisée partout pour garantir la cohérence
  static int generateNotificationId(String medicationId, int timeIndex) {
    // Utiliser hashCode du medicationId et ajouter l'index
    final baseId = medicationId.hashCode.abs() % 100000;
    return baseId * 10 + timeIndex;
  }

  /// Génère un ID unique pour une notification (méthode d'instance)
  int _generateNotificationId(String medicationId, int timeIndex) {
    return NotificationScheduler.generateNotificationId(medicationId, timeIndex);
  }

  /// Vérifie si une notification est planifiée
  Future<bool> isNotificationScheduled(String medicationId, int timeIndex) async {
    final notificationId = _generateNotificationId(medicationId, timeIndex);
    return await _notificationService.isNotificationScheduled(notificationId);
  }

  /// Récupère le nombre de notifications en attente
  Future<int> getPendingNotificationsCount() async {
    final pending = await _notificationService.getPendingNotifications();
    return pending.length;
  }

  /// Planifie une notification de test (pour dans 1 minute)
  Future<void> scheduleTestNotification() async {
    await _notificationService.scheduleTestNotification();
  }

  /// Affiche une notification de test immédiate
  Future<void> showTestNotification() async {
    await _notificationService.showImmediateNotification(
      id: 999998,
      title: '🧪 Test immédiat',
      body: 'Notification de test - si vous voyez ceci, les notifications de base fonctionnent!',
    );
  }

  /// Liste toutes les notifications en attente avec détails
  Future<void> printPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    print('📋 Notifications en attente: ${pending.length}');
    for (final notif in pending) {
      print('   - ID: ${notif.id}, Titre: ${notif.title}, Body: ${notif.body}');
    }
  }
}

