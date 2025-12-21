import 'package:flutter/material.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/features/history/domain/usecases/save_treatment_history_usecase.dart';
import 'package:mediscanhelper/features/history/domain/usecases/get_treatment_history_usecase.dart';
import 'package:mediscanhelper/core/utils/notification_scheduler.dart';

/// Provider pour la gestion des rappels et leur historique
class ReminderProvider with ChangeNotifier {
  final NotificationScheduler notificationScheduler;
  final SaveTreatmentHistory saveTreatmentHistory;
  final GetTreatmentHistory getTreatmentHistory;

  ReminderProvider({
    required this.notificationScheduler,
    required this.saveTreatmentHistory,
    required this.getTreatmentHistory,
  });

  // Liste des traitements historiques
  final List<TreatmentHistory> _treatmentHistory = [];

  // Getters
  List<TreatmentHistory> get treatmentHistory => List.unmodifiable(_treatmentHistory);

  /// Récupère l'historique pour un médicament spécifique
  List<TreatmentHistory> getHistoryForMedication(String medicationId) {
    return _treatmentHistory
        .where((h) => h.medicationId == medicationId)
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  /// Récupère l'historique pour aujourd'hui
  List<TreatmentHistory> getTodayHistory() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _treatmentHistory
        .where((h) {
          final historyDate = DateTime(
            h.scheduledTime.year,
            h.scheduledTime.month,
            h.scheduledTime.day,
          );
          return historyDate == today;
        })
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  /// Récupère l'historique pour cette semaine
  List<TreatmentHistory> getWeekHistory() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return _treatmentHistory
        .where((h) => h.scheduledTime.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
  }

  /// Calcule le nombre de prises à venir pour les médicaments actifs aujourd'hui
  int getPendingDosesCount(List<Medication> activeMedications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int pendingCount = 0;

    for (final medication in activeMedications) {
      for (final time in medication.times) {
        final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

        // Ne compter que les prises à venir (dans le futur ou dans l'heure qui vient)
        if (scheduledTime.isAfter(now.subtract(const Duration(hours: 1)))) {
          final historyId = '${medication.id}_${scheduledTime.millisecondsSinceEpoch}';

          // Vérifier si cette prise n'a pas déjà été traitée
          final existingHistory = _treatmentHistory.firstWhere(
            (h) => h.id == historyId,
            orElse: () => TreatmentHistory(
              id: '',
              medicationId: '',
              medicationName: '',
              dosage: '',
              scheduledTime: DateTime.now(),
              status: TreatmentStatus.pending,
              createdAt: DateTime.now(),
            ),
          );

          // Compter seulement si non traité (pas pris, pas ignoré)
          if (existingHistory.id.isEmpty || existingHistory.status == TreatmentStatus.pending) {
            pendingCount++;
          }
        }
      }
    }

    return pendingCount;
  }

  /// Vérifie si une prise spécifique a été traitée
  bool isDoseTaken(String medicationId, DateTime scheduledTime) {
    final historyId = '${medicationId}_${scheduledTime.millisecondsSinceEpoch}';
    final history = _treatmentHistory.firstWhere(
      (h) => h.id == historyId,
      orElse: () => TreatmentHistory(
        id: '',
        medicationId: '',
        medicationName: '',
        dosage: '',
        scheduledTime: DateTime.now(),
        status: TreatmentStatus.pending,
        createdAt: DateTime.now(),
      ),
    );

    return history.id.isNotEmpty &&
           (history.status == TreatmentStatus.taken ||
            history.status == TreatmentStatus.skipped);
  }

  /// Marque un médicament comme pris
  Future<void> markAsTaken({
    required String medicationId,
    required String medicationName,
    required String dosage,
    required DateTime scheduledTime,
    String? note,
  }) async {
    final takenTime = DateTime.now();
    final historyId = '${medicationId}_${scheduledTime.millisecondsSinceEpoch}';

    // Vérifier si cette prise n'existe pas déjà
    final existingIndex = _treatmentHistory.indexWhere((h) => h.id == historyId);
    if (existingIndex != -1) {
      print('⚠️ Historique déjà existant pour ${medicationName} à ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
      // Mettre à jour l'entrée existante
      _treatmentHistory[existingIndex] = TreatmentHistory(
        id: historyId,
        medicationId: medicationId,
        medicationName: medicationName,
        dosage: dosage,
        scheduledTime: scheduledTime,
        takenTime: takenTime,
        status: TreatmentStatus.taken,
        note: note,
        createdAt: takenTime,
      );
    } else {
      // Créer une nouvelle entrée
      final history = TreatmentHistory(
        id: historyId,
        medicationId: medicationId,
        medicationName: medicationName,
        dosage: dosage,
        scheduledTime: scheduledTime,
        takenTime: takenTime,
        status: TreatmentStatus.taken,
        note: note,
        createdAt: takenTime,
      );
      _treatmentHistory.add(history);
    }

    notifyListeners();

    final delay = takenTime.difference(scheduledTime).inMinutes;
    final delayText = delay > 0 ? '$delay min de retard' : delay < 0 ? '${-delay} min en avance' : 'à l\'heure';
    print('✅ Médicament marqué comme pris: $medicationName');
    print('   Prévu: ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
    print('   Pris: ${takenTime.hour}:${takenTime.minute.toString().padLeft(2, '0')} ($delayText)');

    // Sauvegarder dans Firestore
    final history = _treatmentHistory[existingIndex != -1 ? existingIndex : _treatmentHistory.length - 1];
    await saveTreatmentHistory(SaveTreatmentHistoryParams(history: history));
  }

  /// Marque un médicament comme manqué
  Future<void> markAsMissed({
    required String medicationId,
    required String medicationName,
    required String dosage,
    required DateTime scheduledTime,
    String? note,
  }) async {
    final history = TreatmentHistory(
      id: '${medicationId}_${scheduledTime.millisecondsSinceEpoch}',
      medicationId: medicationId,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      takenTime: null,
      status: TreatmentStatus.missed,
      note: note,
      createdAt: DateTime.now(),
    );

    _treatmentHistory.add(history);
    notifyListeners();

    print('❌ Médicament marqué comme manqué: $medicationName');
  }

  /// Marque un médicament comme ignoré
  Future<void> markAsSkipped({
    required String medicationId,
    required String medicationName,
    required String dosage,
    required DateTime scheduledTime,
    String? note,
  }) async {
    final historyId = '${medicationId}_${scheduledTime.millisecondsSinceEpoch}';

    // Vérifier si cette prise n'existe pas déjà
    final existingIndex = _treatmentHistory.indexWhere((h) => h.id == historyId);
    if (existingIndex != -1) {
      print('⚠️ Historique déjà existant pour ${medicationName} à ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
      // Mettre à jour l'entrée existante
      _treatmentHistory[existingIndex] = TreatmentHistory(
        id: historyId,
        medicationId: medicationId,
        medicationName: medicationName,
        dosage: dosage,
        scheduledTime: scheduledTime,
        takenTime: null,
        status: TreatmentStatus.skipped,
        note: note ?? 'Ignoré volontairement',
        createdAt: DateTime.now(),
      );
    } else {
      // Créer une nouvelle entrée
      final history = TreatmentHistory(
        id: historyId,
        medicationId: medicationId,
        medicationName: medicationName,
        dosage: dosage,
        scheduledTime: scheduledTime,
        takenTime: null,
        status: TreatmentStatus.skipped,
        note: note ?? 'Ignoré volontairement',
        createdAt: DateTime.now(),
      );
      _treatmentHistory.add(history);
    }

    notifyListeners();

    print('⏭️ Médicament marqué comme ignoré: $medicationName');
    print('   Prévu: ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}');
  }

  /// Génère des données d'historique de test basées sur les médicaments
  void generateSampleHistory(List<Medication> medications) {
    _treatmentHistory.clear();

    final now = DateTime.now();

    // Créer de l'historique pour les 7 derniers jours
    for (int day = 0; day < 7; day++) {
      final date = now.subtract(Duration(days: day));

      // Pour chaque médicament actif
      for (final med in medications.where((m) => m.isActive).take(5)) {
        // Pour chaque heure de prise
        for (final time in med.times) {
          final scheduledTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );

          // Ne pas inclure les prises futures
          if (scheduledTime.isAfter(now)) continue;

          // Générer un statut aléatoire (80% pris, 15% manqué, 5% ignoré)
          final random = (scheduledTime.millisecondsSinceEpoch % 100);
          TreatmentStatus status;
          DateTime? takenTime;

          if (random < 80) {
            status = TreatmentStatus.taken;
            // Ajouter un délai aléatoire de -5 à +30 minutes
            final delay = (random % 36) - 5;
            takenTime = scheduledTime.add(Duration(minutes: delay));
          } else if (random < 95) {
            status = TreatmentStatus.missed;
          } else {
            status = TreatmentStatus.skipped;
          }

          _treatmentHistory.add(TreatmentHistory(
            id: '${med.id}_${scheduledTime.millisecondsSinceEpoch}',
            medicationId: med.id,
            medicationName: med.name,
            dosage: med.dosage,
            scheduledTime: scheduledTime,
            takenTime: takenTime,
            status: status,
            note: status == TreatmentStatus.skipped ? 'Sauté volontairement' : null,
            createdAt: scheduledTime,
          ));
        }
      }
    }

    notifyListeners();
    print('📊 Historique de test généré: ${_treatmentHistory.length} entrées');
  }

  /// Calcule les statistiques d'observance
  Map<String, dynamic> getComplianceStats({DateTime? startDate, DateTime? endDate}) {
    List<TreatmentHistory> filteredHistory = _treatmentHistory;

    if (startDate != null) {
      filteredHistory = filteredHistory
          .where((h) => h.scheduledTime.isAfter(startDate))
          .toList();
    }

    if (endDate != null) {
      filteredHistory = filteredHistory
          .where((h) => h.scheduledTime.isBefore(endDate))
          .toList();
    }

    final total = filteredHistory.length;
    final taken = filteredHistory.where((h) => h.status == TreatmentStatus.taken).length;
    final missed = filteredHistory.where((h) => h.status == TreatmentStatus.missed).length;
    final skipped = filteredHistory.where((h) => h.status == TreatmentStatus.skipped).length;
    final pending = filteredHistory.where((h) => h.status == TreatmentStatus.pending).length;

    final complianceRate = total > 0 ? (taken / total * 100) : 0.0;

    return {
      'total': total,
      'taken': taken,
      'missed': missed,
      'skipped': skipped,
      'pending': pending,
      'complianceRate': complianceRate,
    };
  }

  /// Nettoie l'historique ancien (plus de 30 jours)
  void cleanOldHistory() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    _treatmentHistory.removeWhere((h) => h.scheduledTime.isBefore(thirtyDaysAgo));
    notifyListeners();
  }

  /// Supprime l'historique pour un médicament spécifique
  void deleteHistoryForMedication(String medicationId) {
    _treatmentHistory.removeWhere((h) => h.medicationId == medicationId);
    notifyListeners();
  }

  /// Charge l'historique depuis Firestore
  Future<void> loadHistory() async {
    // Charger les 30 derniers jours
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));

    final result = await getTreatmentHistory(
      GetTreatmentHistoryParams(
        startDate: startDate,
        endDate: endDate,
      ),
    );

    result.fold(
      (failure) {
        print('❌ Erreur lors du chargement de l\'historique: ${failure.message}');
      },
      (history) {
        _treatmentHistory.clear();
        _treatmentHistory.addAll(history);
        notifyListeners();
        print('✅ Historique chargé: ${history.length} entrées');
      },
    );
  }

  /// Efface toutes les données (utile lors de la déconnexion)
  void clearAllData() {
    _treatmentHistory.clear();
    notifyListeners();
    print('🗑️ ReminderProvider: Toutes les données ont été effacées');
  }
}

