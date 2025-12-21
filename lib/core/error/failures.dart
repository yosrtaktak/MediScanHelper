import 'package:equatable/equatable.dart';

/// Classe abstraite pour toutes les Failures de l'application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure pour les erreurs de base de données
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Failure pour les erreurs de cache
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure pour les erreurs de permission
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Failure pour les erreurs de scanner
class ScannerFailure extends Failure {
  const ScannerFailure(super.message);
}

/// Failure pour les erreurs de notification
class NotificationFailure extends Failure {
  const NotificationFailure(super.message);
}

/// Failure pour les erreurs de validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure générique
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

