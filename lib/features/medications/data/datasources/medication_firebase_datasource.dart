import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediscanhelper/core/error/exceptions.dart';
import 'package:mediscanhelper/features/medications/data/models/medication_model.dart';
import 'package:mediscanhelper/features/medications/data/datasources/medication_local_datasource.dart';

/// Implémentation Firebase du DataSource pour les médicaments
class MedicationFirebaseDataSource implements MedicationLocalDataSource {
  final FirebaseFirestore firestore;
  final String userId;

  MedicationFirebaseDataSource({
    required this.firestore,
    required this.userId,
  });

  // Collection reference pour les médicaments de l'utilisateur
  CollectionReference get _medicationsRef => firestore
      .collection('users')
      .doc(userId)
      .collection('medications');

  @override
  Future<List<MedicationModel>> getAllMedications() async {
    try {
      final snapshot = await _medicationsRef
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MedicationModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la récupération des médicaments: $e');
    }
  }

  @override
  Future<MedicationModel> getMedicationById(String id) async {
    try {
      final doc = await _medicationsRef.doc(id).get();

      if (!doc.exists) {
        throw DatabaseException('Médicament non trouvé');
      }

      return MedicationModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      });
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la récupération du médicament: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getActiveMedications() async {
    try {
      final snapshot = await _medicationsRef
          .where('is_active', isEqualTo: true)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => MedicationModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la récupération des médicaments actifs: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getInactiveMedications() async {
    try {
      final snapshot = await _medicationsRef
          .where('is_active', isEqualTo: false)
          .orderBy('updated_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MedicationModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la récupération des médicaments inactifs: $e');
    }
  }

  @override
  Future<void> addMedication(MedicationModel medication) async {
    try {
      final data = medication.toJson();
      data.remove('id'); // Firestore génère l'ID automatiquement

      await _medicationsRef.doc(medication.id).set(data);
    } catch (e) {
      throw DatabaseException('Erreur lors de l\'ajout du médicament: $e');
    }
  }

  @override
  Future<void> updateMedication(MedicationModel medication) async {
    try {
      final data = medication.toJson();
      data.remove('id'); // Ne pas inclure l'ID dans les données

      // Mettre à jour la date de modification
      data['updated_at'] = DateTime.now().toIso8601String();

      await _medicationsRef.doc(medication.id).update(data);
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la mise à jour du médicament: $e');
    }
  }

  @override
  Future<void> deleteMedication(String id) async {
    try {
      await _medicationsRef.doc(id).delete();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la suppression du médicament: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getTodayMedications() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Simple query - just get active medications
      final snapshot = await _medicationsRef
          .where('is_active', isEqualTo: true)
          .get();

      // Filter on client side to avoid complex Firestore indexes
      final todayMedications = snapshot.docs
          .map((doc) => MedicationModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .where((med) {
            // Check if medication has started
            if (med.startDate.isAfter(todayEnd)) return false;

            // Check if medication has ended
            if (med.endDate != null && med.endDate!.isBefore(todayStart)) {
              return false;
            }

            // Medication is active and should be taken today
            return true;
          })
          .toList();

      print('📋 Today medications found: ${todayMedications.length}');
      for (final med in todayMedications) {
        print('   - ${med.name} (${med.times.length} times)');
      }

      return todayMedications;
    } catch (e) {
      print('❌ Error in getTodayMedications: $e');
      throw DatabaseException(
          'Erreur lors de la récupération des médicaments du jour: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getExpiringMedications() async {
    try {
      final now = DateTime.now();
      final threeMonthsLater = now.add(const Duration(days: 90));

      final snapshot = await _medicationsRef
          .where('is_active', isEqualTo: true)
          .where('expiry_date', isLessThanOrEqualTo: Timestamp.fromDate(threeMonthsLater))
          .orderBy('expiry_date')
          .get();

      return snapshot.docs
          .map((doc) => MedicationModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la récupération des médicaments expirant: $e');
    }
  }

  /// Stream pour écouter les changements en temps réel
  Stream<List<MedicationModel>> watchMedications() {
    return _medicationsRef
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicationModel.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }))
            .toList());
  }

  /// Stream pour les médicaments actifs
  Stream<List<MedicationModel>> watchActiveMedications() {
    return _medicationsRef
        .where('is_active', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicationModel.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }))
            .toList());
  }

  /// Batch operations pour meilleure performance
  Future<void> addMedications(List<MedicationModel> medications) async {
    try {
      final batch = firestore.batch();

      for (final medication in medications) {
        final data = medication.toJson();
        data.remove('id');
        batch.set(_medicationsRef.doc(medication.id), data);
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de l\'ajout de plusieurs médicaments: $e');
    }
  }

  /// Supprimer tous les médicaments (utile pour reset)
  Future<void> deleteAllMedications() async {
    try {
      final snapshot = await _medicationsRef.get();
      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw DatabaseException(
          'Erreur lors de la suppression de tous les médicaments: $e');
    }
  }
}

