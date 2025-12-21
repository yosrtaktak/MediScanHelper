import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/exceptions.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/medications/data/datasources/medication_local_datasource.dart';
import 'package:mediscanhelper/features/medications/data/models/medication_model.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/features/medications/domain/repositories/medication_repository.dart';

/// Implémentation du repository des médicaments
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource localDataSource;

  MedicationRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Medication>>> getMedications() async {
    try {
      final medications = await localDataSource.getAllMedications();
      return Right(medications);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, Medication>> getMedicationById(String id) async {
    try {
      final medication = await localDataSource.getMedicationById(id);
      return Right(medication);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getActiveMedications() async {
    try {
      final medications = await localDataSource.getActiveMedications();
      return Right(medications);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getInactiveMedications() async {
    try {
      final medications = await localDataSource.getInactiveMedications();
      return Right(medications);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addMedication(Medication medication) async {
    try {
      final medicationModel = MedicationModel.fromEntity(medication);
      await localDataSource.addMedication(medicationModel);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMedication(Medication medication) async {
    try {
      final medicationModel = MedicationModel.fromEntity(medication);
      await localDataSource.updateMedication(medicationModel);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedication(String id) async {
    try {
      await localDataSource.deleteMedication(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getTodayMedications() async {
    try {
      final medications = await localDataSource.getTodayMedications();
      return Right(medications);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getExpiringMedications() async {
    try {
      final medications = await localDataSource.getExpiringMedications();
      return Right(medications);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Erreur inattendue: $e'));
    }
  }
}

