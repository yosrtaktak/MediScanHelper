import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/exceptions.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/history/data/datasources/treatment_history_firebase_datasource.dart';
import 'package:mediscanhelper/features/history/data/models/treatment_history_model.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/features/history/domain/repositories/treatment_history_repository.dart';

/// Implémentation du repository d'historique de traitement
class TreatmentHistoryRepositoryImpl implements TreatmentHistoryRepository {
  final TreatmentHistoryFirebaseDatasource datasource;

  TreatmentHistoryRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, void>> saveTreatmentHistory(
      TreatmentHistory history) async {
    try {
      final model = TreatmentHistoryModel.fromEntity(history);
      await datasource.saveTreatmentHistory(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TreatmentHistory>>> getTreatmentHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final models = await datasource.getTreatmentHistory(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTreatmentHistory(String historyId) async {
    try {
      await datasource.deleteTreatmentHistory(historyId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: ${e.toString()}'));
    }
  }
}
