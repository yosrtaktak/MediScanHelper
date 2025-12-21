import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/features/history/domain/repositories/treatment_history_repository.dart';

/// Use case pour sauvegarder l'historique de traitement
class SaveTreatmentHistory {
  final TreatmentHistoryRepository repository;

  SaveTreatmentHistory(this.repository);

  Future<Either<Failure, void>> call(SaveTreatmentHistoryParams params) async {
    return await repository.saveTreatmentHistory(params.history);
  }
}

class SaveTreatmentHistoryParams extends Equatable {
  final TreatmentHistory history;

  const SaveTreatmentHistoryParams({required this.history});

  @override
  List<Object> get props => [history];
}
