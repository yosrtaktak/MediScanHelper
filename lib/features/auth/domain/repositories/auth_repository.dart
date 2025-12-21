import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/auth/domain/entities/user_entity.dart';

/// Repository abstrait pour l'authentification
abstract class AuthRepository {
  /// Connexion avec email et mot de passe
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Inscription avec email et mot de passe
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Déconnexion
  Future<Either<Failure, void>> signOut();

  /// Récupérer l'utilisateur actuellement connecté
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Vérifier si un utilisateur est connecté
  Future<bool> isSignedIn();

  /// Réinitialisation du mot de passe
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Mettre à jour le profil utilisateur
  Future<Either<Failure, void>> updateProfile({required String displayName});

  /// Stream de l'état d'authentification
  Stream<UserEntity?> get authStateChanges;
}

