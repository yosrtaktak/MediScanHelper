import 'package:flutter/foundation.dart';
import 'package:mediscanhelper/features/auth/domain/entities/user_entity.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:mediscanhelper/features/auth/domain/usecases/update_profile_usecase.dart';

/// Provider pour gérer l'état d'authentification
class AuthProvider extends ChangeNotifier {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final ResetPassword resetPassword;
  final UpdateProfile updateProfileUseCase;

  AuthProvider({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.getCurrentUser,
    required this.resetPassword,
    required this.updateProfileUseCase,
  });

  // État
  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Connexion
  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearMessages();

    final result = await signIn(SignInParams(
      email: email,
      password: password,
    ));

    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _setLoading(false);
        return false;
      },
          (user) {
        _currentUser = user;
        _successMessage = 'Connexion réussie !';
        _setLoading(false);
        return true;
      },
    );
  }

  /// Inscription
  Future<bool> signUpUser({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _clearMessages();

    final result = await signUp(SignUpParams(
      email: email,
      password: password,
      displayName: displayName,
    ));

    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _setLoading(false);
        return false;
      },
          (user) {
        _currentUser = user;
        _successMessage = 'Compte créé avec succès !';
        _setLoading(false);
        return true;
      },
    );
  }

  /// Déconnexion
  Future<bool> signOutUser() async {
    print('🔓 AuthProvider: signOutUser called');
    _setLoading(true);
    _clearMessages();

    print('🔓 AuthProvider: Calling signOut use case...');
    final result = await signOut();

    return result.fold(
          (failure) {
        print('🔓 AuthProvider: SignOut failed - ${failure.message}');
        _errorMessage = failure.message;
        _setLoading(false);
        return false;
      },
          (_) {
        print('🔓 AuthProvider: SignOut succeeded, clearing user state');
        _currentUser = null;
        _successMessage = 'Déconnexion réussie';
        _setLoading(false);
        print('🔓 AuthProvider: User cleared, isAuthenticated = $isAuthenticated');
        return true;
      },
    );
  }

  /// Récupérer l'utilisateur actuel
  Future<void> loadCurrentUser() async {
    final result = await getCurrentUser();

    result.fold(
          (failure) {
        _currentUser = null;
      },
          (user) {
        _currentUser = user;
      },
    );

    notifyListeners();
  }

  /// Réinitialiser le mot de passe
  Future<bool> resetUserPassword({required String email}) async {
    _setLoading(true);
    _clearMessages();

    final result = await resetPassword(ResetPasswordParams(email: email));

    return result.fold(
          (failure) {
        _errorMessage = failure.message;
        _setLoading(false);
        return false;
      },
          (_) {
        _successMessage = 'Email de réinitialisation envoyé !';
        _setLoading(false);
        return true;
      },
    );
  }

  /// Effacer les messages
  void clearMessages() {
    _clearMessages();
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  /// Mettre à jour le profil (Nom d'affichage)
  Future<bool> updateProfile({required String displayName}) async {
    _setLoading(true);
    _clearMessages();
    
    final result = await updateProfileUseCase(UpdateProfileParams(displayName: displayName));

    return await result.fold(
      (failure) async {
        _errorMessage = failure.message;
        _setLoading(false);
        return false;
      },
      (_) async {
        // Re-charger l'utilisateur pour avoir les données à jour
        await loadCurrentUser();
        _successMessage = 'Profil mis à jour avec succès';
        _setLoading(false);
        return true;
      },
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

