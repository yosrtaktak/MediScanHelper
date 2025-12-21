import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediscanhelper/core/theme/theme_provider.dart';
import 'package:mediscanhelper/core/theme/settings_provider.dart';
import 'package:mediscanhelper/core/utils/feedback_service.dart';
import 'package:mediscanhelper/core/utils/notification_service.dart';
import 'package:mediscanhelper/core/utils/notification_scheduler.dart';
import 'package:mediscanhelper/core/services/barcode_scanner_service.dart';
import 'package:mediscanhelper/core/services/barcode_validation_service.dart';

// Auth
import 'package:mediscanhelper/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mediscanhelper/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mediscanhelper/features/auth/domain/repositories/auth_repository.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:mediscanhelper/features/auth/presentation/providers/auth_provider.dart' as auth;

// Medications
import 'package:mediscanhelper/features/medications/data/datasources/medication_local_datasource.dart';
import 'package:mediscanhelper/features/medications/data/datasources/medication_firebase_datasource.dart';
import 'package:mediscanhelper/features/medications/data/repositories/medication_repository_impl.dart';
import 'package:mediscanhelper/features/medications/domain/repositories/medication_repository.dart';
import 'package:mediscanhelper/features/medications/domain/usecases/medication_usecases.dart';
import 'package:mediscanhelper/features/medications/presentation/providers/medication_provider.dart';

// Reminders
import 'package:mediscanhelper/features/reminders/presentation/providers/reminder_provider.dart';

// Treatment History
import 'package:mediscanhelper/features/history/data/datasources/treatment_history_firebase_datasource.dart';
import 'package:mediscanhelper/features/history/data/repositories/treatment_history_repository_impl.dart';
import 'package:mediscanhelper/features/history/domain/repositories/treatment_history_repository.dart';
import 'package:mediscanhelper/features/history/domain/usecases/save_treatment_history_usecase.dart';
import 'package:mediscanhelper/features/history/domain/usecases/get_treatment_history_usecase.dart';

/// Instance globale de GetIt pour l'injection de dépendances
final sl = GetIt.instance;

/// Initialise toutes les dépendances de l'application
Future<void> init() async {
  // ============================================
  // Providers
  // ============================================

  // Theme Provider
  sl.registerLazySingleton<ThemeProvider>(
        () => ThemeProvider(sl()),
  );

  // Settings Provider
  sl.registerLazySingleton<SettingsProvider>(
        () => SettingsProvider(sl()),
  );

  // Feedback Service
  sl.registerLazySingleton<FeedbackService>(
        () => FeedbackService(sl()),
  );

  // Notification Service
  sl.registerLazySingleton<NotificationService>(
        () => NotificationService(),
  );

  // Notification Scheduler
  sl.registerLazySingleton<NotificationScheduler>(
        () => NotificationScheduler(sl()),
  );

  // Barcode Scanner Service
  sl.registerLazySingleton<BarcodeScannerService>(
        () => BarcodeScannerService(),
  );

  // Barcode Validation Service
  sl.registerLazySingleton<BarcodeValidationService>(
        () => BarcodeValidationService(),
  );

  // Auth Provider
  sl.registerLazySingleton<auth.AuthProvider>(
        () => auth.AuthProvider(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      resetPassword: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // Medication Provider
  sl.registerLazySingleton<MedicationProvider>(
        () => MedicationProvider(
      getMedications: sl(),
      getActiveMedications: sl(),
      getMedicationById: sl(),
      addMedication: sl(),
      updateMedication: sl(),
      deleteMedication: sl(),
      getTodayMedications: sl(),
      getExpiringMedications: sl(),
      notificationScheduler: sl(),
    ),
  );

  // Reminder Provider
  sl.registerLazySingleton<ReminderProvider>(
        () => ReminderProvider(
      notificationScheduler: sl(),
      saveTreatmentHistory: sl(),
      getTreatmentHistory: sl(),
    ),
  );

  // ============================================
  // UseCases - Auth
  // ============================================

  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  // ============================================
  // UseCases - Medications
  // ============================================

  sl.registerLazySingleton(() => GetMedications(sl()));
  sl.registerLazySingleton(() => GetActiveMedications(sl()));
  sl.registerLazySingleton(() => GetMedicationById(sl()));
  sl.registerLazySingleton(() => AddMedication(sl()));
  sl.registerLazySingleton(() => UpdateMedication(sl()));
  sl.registerLazySingleton(() => DeleteMedication(sl()));
  sl.registerLazySingleton(() => GetTodayMedications(sl()));
  sl.registerLazySingleton(() => GetExpiringMedications(sl()));

  // ============================================
  // UseCases - Treatment History
  // ============================================

  sl.registerLazySingleton(() => SaveTreatmentHistory(sl()));
  sl.registerLazySingleton(() => GetTreatmentHistory(sl()));

  // ============================================
  // Repositories
  // ============================================

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Medication Repository
  sl.registerLazySingleton<MedicationRepository>(
        () => MedicationRepositoryImpl(sl()),
  );

  // Treatment History Repository
  sl.registerLazySingleton<TreatmentHistoryRepository>(
        () => TreatmentHistoryRepositoryImpl(sl()),
  );

  // ============================================
  // DataSources
  // ============================================

  // Auth Remote DataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );

  // Medication Firebase DataSource - uses current user ID dynamically
  sl.registerFactory<MedicationLocalDataSource>(
        () {
      final currentUser = sl<FirebaseAuth>().currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated to access medications');
      }
      return MedicationFirebaseDataSource(
        firestore: sl<FirebaseFirestore>(),
        userId: currentUser.uid,
      );
    },
  );

  // Treatment History Firebase DataSource - uses current user ID dynamically
  sl.registerFactory<TreatmentHistoryFirebaseDatasource>(
        () {
      final currentUser = sl<FirebaseAuth>().currentUser;
      if (currentUser == null) {
        throw Exception('User must be authenticated to access treatment history');
      }
      return TreatmentHistoryFirebaseDatasourceImpl(
        firestore: sl<FirebaseFirestore>(),
        userId: currentUser.uid,
      );
    },
  );

  // ============================================
  // External
  // ============================================

  // Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firebase Firestore
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
