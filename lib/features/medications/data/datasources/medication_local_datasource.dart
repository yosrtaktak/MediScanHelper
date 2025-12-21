import 'package:sqflite/sqflite.dart';
import 'package:mediscanhelper/core/error/exceptions.dart' as core_exceptions;
import 'package:mediscanhelper/features/medications/data/models/medication_model.dart';

/// DataSource local pour les médicaments (SQLite)
abstract class MedicationLocalDataSource {
  /// Récupère tous les médicaments
  Future<List<MedicationModel>> getAllMedications();

  /// Récupère un médicament par son ID
  Future<MedicationModel> getMedicationById(String id);

  /// Récupère les médicaments actifs
  Future<List<MedicationModel>> getActiveMedications();

  /// Récupère les médicaments inactifs
  Future<List<MedicationModel>> getInactiveMedications();

  /// Ajoute un nouveau médicament
  Future<void> addMedication(MedicationModel medication);

  /// Met à jour un médicament existant
  Future<void> updateMedication(MedicationModel medication);

  /// Supprime un médicament
  Future<void> deleteMedication(String id);

  /// Récupère les médicaments à prendre aujourd'hui
  Future<List<MedicationModel>> getTodayMedications();

  /// Récupère les médicaments expirés ou expirant bientôt
  Future<List<MedicationModel>> getExpiringMedications();
}

/// Implémentation du DataSource local
class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  final Database database;

  MedicationLocalDataSourceImpl(this.database);

  @override
  Future<List<MedicationModel>> getAllMedications() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'medications',
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => MedicationModel.fromJson(map)).toList();
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la récupération des médicaments: $e');
    }
  }

  @override
  Future<MedicationModel> getMedicationById(String id) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'medications',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        throw core_exceptions.DatabaseException('Médicament non trouvé');
      }

      return MedicationModel.fromJson(maps.first);
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la récupération du médicament: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getActiveMedications() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'medications',
        where: 'is_active = ?',
        whereArgs: [1],
        orderBy: 'name ASC',
      );
      return maps.map((map) => MedicationModel.fromJson(map)).toList();
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la récupération des médicaments actifs: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getInactiveMedications() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'medications',
        where: 'is_active = ?',
        whereArgs: [0],
        orderBy: 'updated_at DESC',
      );
      return maps.map((map) => MedicationModel.fromJson(map)).toList();
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la récupération des médicaments inactifs: $e');
    }
  }

  @override
  Future<void> addMedication(MedicationModel medication) async {
    try {
      await database.insert(
        'medications',
        medication.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de l\'ajout du médicament: $e');
    }
  }

  @override
  Future<void> updateMedication(MedicationModel medication) async {
    try {
      final result = await database.update(
        'medications',
        medication.toJson(),
        where: 'id = ?',
        whereArgs: [medication.id],
      );

      if (result == 0) {
        throw core_exceptions.DatabaseException('Médicament non trouvé pour mise à jour');
      }
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la mise à jour du médicament: $e');
    }
  }

  @override
  Future<void> deleteMedication(String id) async {
    try {
      final result = await database.delete(
        'medications',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result == 0) {
        throw core_exceptions.DatabaseException('Médicament non trouvé pour suppression');
      }
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la suppression du médicament: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getTodayMedications() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final List<Map<String, dynamic>> maps = await database.query(
        'medications',
        where: 'is_active = ? AND start_date <= ? AND (end_date IS NULL OR end_date >= ?)',
        whereArgs: [
          1,
          todayEnd.toIso8601String(),
          todayStart.toIso8601String(),
        ],
        orderBy: 'name ASC',
      );

      return maps.map((map) => MedicationModel.fromJson(map)).toList();
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la récupération des médicaments du jour: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getExpiringMedications() async {
    try {
      final now = DateTime.now();
      final threeMonthsLater = now.add(const Duration(days: 90));

      final List<Map<String, dynamic>> maps = await database.query(
        'medications',
        where: 'is_active = ? AND expiry_date IS NOT NULL AND expiry_date <= ?',
        whereArgs: [1, threeMonthsLater.toIso8601String()],
        orderBy: 'expiry_date ASC',
      );

      return maps.map((map) => MedicationModel.fromJson(map)).toList();
    } catch (e) {
      throw core_exceptions.DatabaseException('Erreur lors de la récupération des médicaments expirant: $e');
    }
  }
}

