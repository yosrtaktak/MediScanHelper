import 'package:dartz/dartz.dart';
import 'package:mediscanhelper/core/error/failures.dart';
import 'package:mediscanhelper/features/auth/domain/repositories/auth_repository.dart';

/// Use case pour la déconnexion
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}

