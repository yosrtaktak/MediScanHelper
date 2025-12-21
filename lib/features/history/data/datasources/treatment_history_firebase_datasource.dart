import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediscanhelper/core/error/exceptions.dart';
import 'package:mediscanhelper/features/history/data/models/treatment_history_model.dart';

/// Interface pour la source de données Firestore de l'historique
abstract class TreatmentHistoryFirebaseDatasource {
  Future<void> saveTreatmentHistory(TreatmentHistoryModel history);
  Future<List<TreatmentHistoryModel>> getTreatmentHistory({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<void> deleteTreatmentHistory(String historyId);
}

/// Implémentation Firestore de la source de données
class TreatmentHistoryFirebaseDatasourceImpl
    implements TreatmentHistoryFirebaseDatasource {
  final FirebaseFirestore firestore;
  final String userId;

  TreatmentHistoryFirebaseDatasourceImpl({
    required this.firestore,
    required this.userId,
  });

  /// Collection path
  String get _collectionPath => 'users/$userId/treatment_history';

  @override
  Future<void> saveTreatmentHistory(TreatmentHistoryModel history) async {
    try {
      await firestore
          .collection(_collectionPath)
          .doc(history.id)
          .set(history.toJson());
    } catch (e) {
      throw ServerException(
          'Erreur lors de la sauvegarde de l\'historique: ${e.toString()}');
    }
  }

  @override
  Future<List<TreatmentHistoryModel>> getTreatmentHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection(_collectionPath)
          .where('scheduledTime',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('scheduledTime',
              isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('scheduledTime', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TreatmentHistoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(
          'Erreur lors de la récupération de l\'historique: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTreatmentHistory(String historyId) async {
    try {
      await firestore.collection(_collectionPath).doc(historyId).delete();
    } catch (e) {
      throw ServerException(
          'Erreur lors de la suppression de l\'historique: ${e.toString()}');
    }
  }
}
