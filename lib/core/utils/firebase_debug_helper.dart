import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediscanhelper/features/medications/domain/entities/medication.dart';
import 'package:mediscanhelper/injection_container.dart' as di;
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Helper class pour déboguer et tester l'intégration Firebase
class FirebaseDebugHelper {

  /// Vérifie que l'utilisateur est authentifié
  static Future<bool> checkAuthentication() async {
    try {
      final firebaseAuth = di.sl<FirebaseAuth>();
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        debugPrint('❌ Aucun utilisateur authentifié');
        return false;
      }

      debugPrint('✅ Utilisateur authentifié: ${currentUser.email}');
      debugPrint('   User ID: ${currentUser.uid}');
      return true;
    } catch (e) {
      debugPrint('❌ Erreur lors de la vérification de l\'authentification: $e');
      return false;
    }
  }

  /// Teste l'ajout d'un médicament dans Firebase
  static Future<bool> testAddMedication() async {
    try {
      if (!await checkAuthentication()) {
        debugPrint('⚠️ Test annulé: utilisateur non authentifié');
        return false;
      }

      final provider = di.sl<MedicationProvider>();

      // Créer un médicament de test
      final testMedication = Medication(
        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Paracétamol (TEST)',
        dosage: '500mg',
        frequency: 3,
        times: const [
          TimeOfDay(hour: 8, minute: 0),
          TimeOfDay(hour: 13, minute: 0),
          TimeOfDay(hour: 20, minute: 0),
        ],
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      debugPrint('📝 Tentative d\'ajout du médicament de test...');
      final success = await provider.addNewMedication(testMedication);

      if (success) {
        debugPrint('✅ Médicament de test ajouté avec succès!');
        debugPrint('   Vérifiez Firebase Console: users/{userId}/medications/${testMedication.id}');
        return true;
      } else {
        debugPrint('❌ Échec de l\'ajout du médicament');
        if (provider.errorMessage != null) {
          debugPrint('   Erreur: ${provider.errorMessage}');
        }
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Exception lors du test: $e');
      debugPrint('   Stack trace: $stackTrace');
      return false;
    }
  }

  /// Teste la récupération des médicaments depuis Firebase
  static Future<bool> testGetMedications() async {
    try {
      if (!await checkAuthentication()) {
        debugPrint('⚠️ Test annulé: utilisateur non authentifié');
        return false;
      }

      final provider = di.sl<MedicationProvider>();

      debugPrint('📝 Chargement des médicaments...');
      await provider.loadMedications();

      if (provider.errorMessage != null) {
        debugPrint('❌ Erreur lors du chargement: ${provider.errorMessage}');
        return false;
      }

      final medications = provider.medications;
      debugPrint('✅ ${medications.length} médicament(s) chargé(s)');

      for (var i = 0; i < medications.length; i++) {
        final med = medications[i];
        debugPrint('   ${i + 1}. ${med.name} - ${med.dosage} (${med.frequency}x/jour)');
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Exception lors du test: $e');
      debugPrint('   Stack trace: $stackTrace');
      return false;
    }
  }

  /// Affiche les informations de configuration Firebase
  static void printFirebaseConfig() {
    debugPrint('═══════════════════════════════════════');
    debugPrint('Configuration Firebase');
    debugPrint('═══════════════════════════════════════');

    try {
      final firebaseAuth = di.sl<FirebaseAuth>();
      final currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        debugPrint('✅ Utilisateur: ${currentUser.email}');
        debugPrint('   UID: ${currentUser.uid}');
        debugPrint('   Path Firestore: users/${currentUser.uid}/medications');
      } else {
        debugPrint('❌ Aucun utilisateur connecté');
      }
    } catch (e) {
      debugPrint('❌ Erreur: $e');
    }

    debugPrint('═══════════════════════════════════════');
  }

  /// Exécute tous les tests de diagnostic
  static Future<void> runAllDiagnostics() async {
    debugPrint('\n');
    debugPrint('╔═══════════════════════════════════════╗');
    debugPrint('║  DIAGNOSTIC FIREBASE FIRESTORE       ║');
    debugPrint('╚═══════════════════════════════════════╝');
    debugPrint('');

    // Test 1: Authentication
    debugPrint('Test 1: Vérification de l\'authentification');
    debugPrint('-------------------------------------------');
    await checkAuthentication();
    debugPrint('');

    // Test 2: Configuration
    debugPrint('Test 2: Configuration Firebase');
    debugPrint('-------------------------------------------');
    printFirebaseConfig();
    debugPrint('');

    // Test 3: Récupération des médicaments
    debugPrint('Test 3: Récupération des médicaments');
    debugPrint('-------------------------------------------');
    await testGetMedications();
    debugPrint('');

    // Test 4: Ajout d'un médicament (optionnel - décommenter pour tester)
    // debugPrint('Test 4: Ajout d\'un médicament de test');
    // debugPrint('-------------------------------------------');
    // await testAddMedication();
    // debugPrint('');

    debugPrint('╔═══════════════════════════════════════╗');
    debugPrint('║  FIN DU DIAGNOSTIC                   ║');
    debugPrint('╚═══════════════════════════════════════╝');
    debugPrint('\n');
  }
}

