import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/history/domain/entities/treatment_history.dart';
import 'package:mediscanhelper/features/history/domain/repositories/treatment_history_repository.dart';

/// Use case pour récupérer l'historique de traitement
class GetTreatmentHistory {
  final TreatmentHistoryRepository repository;

  GetTreatmentHistory(this.repository);

  Future<Either<Failure, List<TreatmentHistory>>> call(
      GetTreatmentHistoryParams params) async {
    return await repository.getTreatmentHistory(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetTreatmentHistoryParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetTreatmentHistoryParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}
