import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';

/// Repository abstrait pour l'historique de traitement
abstract class TreatmentHistoryRepository {
  Future<Either<Failure, void>> saveTreatmentHistory(TreatmentHistory history);
  
  Future<Either<Failure, List<TreatmentHistory>>> getTreatmentHistory({
    required DateTime startDate,
    required DateTime endDate,
  });
  
  Future<Either<Failure, void>> deleteTreatmentHistory(String historyId);
}
