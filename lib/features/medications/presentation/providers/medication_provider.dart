import 'package:flutter/material.dart';
import 'package:mediscanhelper/core/utils/notification_scheduler.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/medications/domain/usecases/medication_usecases.dart';

/// Provider pour la gestion des médicaments
class MedicationProvider with ChangeNotifier {
  final GetMedications getMedications;
  final GetActiveMedications getActiveMedications;
  final GetMedicationById getMedicationById;
  final AddMedication addMedication;
  final UpdateMedication updateMedication;
  final DeleteMedication deleteMedication;
  final GetTodayMedications getTodayMedications;
  final GetExpiringMedications getExpiringMedications;
  final NotificationScheduler? notificationScheduler;

  MedicationProvider({
    required this.getMedications,
    required this.getActiveMedications,
    required this.getMedicationById,
    required this.addMedication,
    required this.updateMedication,
    required this.deleteMedication,
    required this.getTodayMedications,
    required this.getExpiringMedications,
    this.notificationScheduler,
  });

  // État
  List<Medication> _medications = [];
  List<Medication> _todayMedications = [];
  List<Medication> _expiringMedications = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _showActiveOnly = true;

  // Getters
  List<Medication> get medications => _showActiveOnly
      ? _medications.where((m) => m.isActive).toList()
      : _medications;

  /// Get all medications without any filtering
  List<Medication> get allMedications => _medications;
  
  /// Get only active medications
  List<Medication> get activeMedications => _medications.where((m) => m.isActive).toList();

  List<Medication> get todayMedications => _todayMedications;
  List<Medication> get expiringMedications => _expiringMedications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get showActiveOnly => _showActiveOnly;

  int get activeMedicationsCount =>
      _medications.where((m) => m.isActive).length;
  int get inactiveMedicationsCount =>
      _medications.where((m) => !m.isActive).length;
  int get totalMedicationsCount => _medications.length;

  /// Toggle entre affichage actif/tous
  void toggleShowActive() {
    _showActiveOnly = !_showActiveOnly;
    notifyListeners();
  }

  /// Charge tous les médicaments
  Future<void> loadMedications() async {
    print('📦 MedicationProvider: Loading all medications...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getMedications();

    result.fold(
      (failure) {
        print('❌ MedicationProvider: Error loading medications: ${failure.message}');
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (medications) {
        _medications = medications;
        _errorMessage = null;
        _isLoading = false;
        print('✅ MedicationProvider: Loaded ${medications.length} total medications');
        print('✅ MedicationProvider: ${medications.where((m) => m.isActive).length} active medications');
        notifyListeners();
      },
    );
  }

  /// Charge les médicaments du jour
  Future<void> loadTodayMedications() async {
    print('📅 MedicationProvider: Loading today medications...');
    final result = await getTodayMedications();

    result.fold(
      (failure) {
        print('❌ MedicationProvider: Error loading today medications: ${failure.message}');
        // Clear the list on error
        _todayMedications = [];
        notifyListeners();
      },
      (medications) {
        _todayMedications = medications;
        print('✅ MedicationProvider: Loaded ${medications.length} today medications');
        for (final med in medications) {
          print('   - ${med.name}: ${med.times.length} times, active: ${med.isActive}');
        }
        notifyListeners();
      },
    );
  }

  /// Charge les médicaments expirant
  Future<void> loadExpiringMedications() async {
    final result = await getExpiringMedications();

    result.fold(
      (failure) {
        // Gérer silencieusement
      },
      (medications) {
        _expiringMedications = medications;
        notifyListeners();
      },
    );
  }

  /// Ajoute un nouveau médicament
  Future<bool> addNewMedication(Medication medication) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await addMedication(medication);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) async {
        _isLoading = false;
        // Recharger la liste
        await loadMedications();
        await loadTodayMedications();

        // Planifier les notifications pour ce médicament
        if (notificationScheduler != null) {
          await notificationScheduler!.scheduleMedicationNotifications(medication);
        }

        return true;
      },
    );
  }

  /// Met à jour un médicament
  Future<bool> updateExistingMedication(Medication medication) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await updateMedication(medication);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) async {
        _isLoading = false;
        // Recharger la liste
        await loadMedications();
        await loadTodayMedications();

        // Reprogrammer les notifications pour ce médicament
        if (notificationScheduler != null) {
          await notificationScheduler!.scheduleMedicationNotifications(medication);
        }

        return true;
      },
    );
  }

  /// Supprime un médicament
  Future<bool> removeMedication(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Récupérer le médicament avant de le supprimer pour annuler ses notifications
    final medication = await getMedicationDetails(id);

    final result = await deleteMedication(id);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) async {
        _isLoading = false;

        // Annuler les notifications pour ce médicament
        if (medication != null && notificationScheduler != null) {
          await notificationScheduler!.cancelMedicationNotifications(medication);
        }

        // Recharger la liste
        await loadMedications();
        await loadTodayMedications();
        return true;
      },
    );
  }

  /// Récupère un médicament par son ID
  Future<Medication?> getMedicationDetails(String id) async {
    final result = await getMedicationById(id);

    return result.fold(
      (failure) => null,
      (medication) => medication,
    );
  }

  /// Active ou désactive un médicament
  Future<bool> toggleMedicationActive(Medication medication) async {
    final updatedMedication = medication.copyWith(
      isActive: !medication.isActive, // Toggle l'état actif
      updatedAt: DateTime.now(), // Mettre à jour la date de modification
    );

    final success = await updateExistingMedication(updatedMedication);

    if (success) {
      print('✅ Médicament ${medication.name} ${updatedMedication.isActive ? "activé" : "désactivé"}');
    }

    return success;
  }

  /// Efface le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Efface toutes les données (utile lors de la déconnexion)
  void clearAllData() {
    _medications = [];
    _todayMedications = [];
    _expiringMedications = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
    print('🗑️ MedicationProvider: Toutes les données ont été effacées');
  }
}

