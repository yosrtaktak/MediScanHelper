import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';

/// Interface du repository pour les médicaments
abstract class MedicationRepository {
  /// Récupère tous les médicaments
  Future<Either<Failure, List<Medication>>> getMedications();

  /// Récupère un médicament par son ID
  Future<Either<Failure, Medication>> getMedicationById(String id);

  /// Récupère les médicaments actifs
  Future<Either<Failure, List<Medication>>> getActiveMedications();

  /// Récupère les médicaments inactifs
  Future<Either<Failure, List<Medication>>> getInactiveMedications();

  /// Ajoute un nouveau médicament
  Future<Either<Failure, void>> addMedication(Medication medication);

  /// Met à jour un médicament existant
  Future<Either<Failure, void>> updateMedication(Medication medication);

  /// Supprime un médicament
  Future<Either<Failure, void>> deleteMedication(String id);

  /// Récupère les médicaments à prendre aujourd'hui
  Future<Either<Failure, List<Medication>>> getTodayMedications();

  /// Récupère les médicaments expirés ou expirant bientôt
  Future<Either<Failure, List<Medication>>> getExpiringMedications();
}

