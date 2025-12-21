import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediscanhelper/core/error/exceptions.dart';
import 'package:mediscanhelper/features/auth/data/models/user_model.dart';

/// Interface pour la source de données distante d'authentification
abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<bool> isSignedIn();

  Future<void> resetPassword({required String email});

  Future<void> updateProfile({required String displayName});

  Stream<UserModel?> get authStateChanges;
}

/// Implémentation de la source de données distante avec Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerException('Échec de la connexion');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getErrorMessage(e.code));
    } catch (e) {
      throw ServerException('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerException('Échec de l\'inscription');
      }

      // Mettre à jour le nom d'affichage
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();

      final updatedUser = firebaseAuth.currentUser!;
      return UserModel.fromFirebaseUser(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getErrorMessage(e.code));
    } catch (e) {
      throw ServerException('Erreur d\'inscription: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      print('🔓 FirebaseAuth: Signing out...');
      await firebaseAuth.signOut();
      print('🔓 FirebaseAuth: Sign out successful');
    } catch (e) {
      print('🔓 FirebaseAuth: Sign out failed - $e');
      throw ServerException('Erreur de déconnexion: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw ServerException('Erreur lors de la récupération de l\'utilisateur: ${e.toString()}');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getErrorMessage(e.code));
    } catch (e) {
      throw ServerException('Erreur de réinitialisation: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile({required String displayName}) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw const ServerException('Utilisateur non connecté');
      }
      await user.updateDisplayName(displayName);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getErrorMessage(e.code));
    } catch (e) {
      throw ServerException('Erreur de mise à jour du profil: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  /// Obtenir un message d'erreur convivial
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'network-request-failed':
        return 'Erreur de connexion réseau';
      default:
        return 'Une erreur est survenue: $code';
    }
  }
}

